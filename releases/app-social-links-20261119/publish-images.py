"""Build and publish frozen HTML/CSS overlays only. Run on isolated GitHub runner."""
import subprocess,json,pathlib,hashlib,tarfile,re,tempfile,os
p=pathlib.Path(__file__).parent
plan=json.load(open(p/'build-plan.json'));receipts=[]
def run(*args):return subprocess.run(args,check=True,capture_output=True,text=True).stdout
def inspect(image):return json.loads(run('docker','image','inspect',image))[0]
for row in plan:
 key=row['key'];base=row['image'];tag=row['candidate_tag'];context=p/'contexts'/key
 assert (context/'Dockerfile').read_text()=='FROM '+base+'\nCOPY overlay/ '+row['root']+'/\n'
 run('docker','pull','--platform=linux/amd64',base)
 cid=run('docker','create','--platform=linux/amd64',base).strip()
 try:
  for change in row['changed']:
   if change['before_sha256'] is not None:
    with tempfile.TemporaryDirectory() as tmp:
     f=pathlib.Path(tmp)/'file';run('docker','cp',cid+':'+change['path'],str(f));assert hashlib.sha256(f.read_bytes()).hexdigest()==change['before_sha256'],change['path']
   assert hashlib.sha256((context/'overlay'/change['relative']).read_bytes()).hexdigest()==change['after_sha256']
 finally:run('docker','rm',cid)
 run('docker','build','--platform=linux/amd64','--network=none','--tag',tag,str(context))
 before=inspect(base);after=inspect(tag)
 diff={k:{'before':before['Config'].get(k),'after':after['Config'].get(k)} for k in set(before['Config'])|set(after['Config']) if before['Config'].get(k)!=after['Config'].get(k)}
 if diff: print('Config differences:', {k:v if k in ('ArgsEscaped','OnBuild','Shell','StopSignal') else 'values omitted' for k,v in diff.items()},flush=True)
 assert not diff,'runtime configuration changed'
 assert after['RootFS']['Layers'][:-1]==before['RootFS']['Layers'],'base filesystem changed'
 # Inspect the sole added layer: it may contain only the approved header assets.
 with tempfile.TemporaryDirectory() as tmp:
  archive=pathlib.Path(tmp)/'image.tar';run('docker','save','--output',str(archive),tag)
  with tarfile.open(archive) as outer:
   m=json.load(outer.extractfile('manifest.json'))[0];layer=m['Layers'][-1]
   with tarfile.open(fileobj=outer.extractfile(layer)) as tar:
    files={x.name.lstrip('./') for x in tar if x.isfile()}
  assert files=={x['path'].lstrip('/') for x in row['changed']},files
 print(row['app'],key,'qualified: runtime config and all base layers unchanged',flush=True)
 receipts.append(dict(row,image_id=after['Id'],runtime_configuration_unchanged=True,base_layers_unchanged=True,overlay_allowlist_verified=True))
(p/'qualification.json').write_text(json.dumps(receipts,indent=2)+'\n')
for row in receipts:
 out=run('docker','push',row['candidate_tag']);digest=re.findall(r'digest: (sha256:[0-9a-f]{64})',out)[-1]
 row['reference']=row['candidate_tag'].split(':')[0]+'@'+digest
 print(row['app'],row['reference'],flush=True)
(p/'published-images.json').write_text(json.dumps(receipts,indent=2)+'\n')
