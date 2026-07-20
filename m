Received: from a8-156.smtp-out.amazonses.com (a8-156.smtp-out.amazonses.com [54.240.8.156])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A836396B9A;
	Mon, 20 Jul 2026 03:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519052; cv=none; b=obvSyr3IW79UJJo7uT/QNqt5f9AiXnF3nPjuVAAR65Vn+J7LNBIG9aR6N9W+pqP4rbPKuNSGXN1OoSCMuwUvNL8MUhsi/CBIcnloU19zktSC7A78shZGYWpDhNDjXFNvJ4LjUjaWhcsGF0R1Gqwucedwe12t9ifUEMScWCcnjkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519052; c=relaxed/simple;
	bh=AYi4kS8nACJSV8gg4cuNDt7Bn8IK/s4muzTXR5iwHGU=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=HAgQsy0OohxlFsPZduP38xkNNvlddDpQR2toX+/JToHtbNpX13ZGOqEyA0R1e+RksA5h94ox7C3mCFklqZhxalirEkWuQvlTkOtMmU5AfLPA+pyLTsGHMLdJ06VRmqOsfjE4lXItrCB5kI9MI6vIoPakRsjCPV4TB3rdHP/+P/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Bi0JkhBK; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=AzeT3elp; arc=none smtp.client-ip=54.240.8.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Bi0JkhBK";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="AzeT3elp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519049;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=AYi4kS8nACJSV8gg4cuNDt7Bn8IK/s4muzTXR5iwHGU=;
	b=Bi0JkhBKZaChtA3WRx5Ig7L1liUZM5V73xWoEN8HfehM6PdlQ1j/YYSsyke/3N1y
	duWDa3Z1ky2acb6Hn/BBil0G0wjC/oW8sLa7MUlz9+lhOTljHm0Z8EcQ9RwWyXvjkyi
	i32OTp6NKwmE9SjGeBkYJN5NlfYDNDGVl3Far5GM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519049;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=AYi4kS8nACJSV8gg4cuNDt7Bn8IK/s4muzTXR5iwHGU=;
	b=AzeT3elpFV4SDnunAoMVDdmY/axwBHTE0D/krK2wPezZOoR9dvrFcoFcPtygevxz
	FKoAkKU+jxLx+1FcD3N90jaIu7P0UgtBx/bClBep6bD1uubVaBFk1yRJtc/RzGmKKxT
	tChE7oVjVjH0Q9voAsvITJMiGczcN0V+UHsXEfpg=
Subject: [PATCH V11 0/9] famfs: port into fuse
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 20 Jul 2026 03:44:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260720034358.68714-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYw==
Thread-Topic: [PATCH V11 0/9] famfs: port into fuse
X-Wm-Sent-Timestamp: 1784519047
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.8.156

From: John Groves <john@groves.net>=0D=0A=0D=0AThis has been quite a gaun=
tlet so far. Some requests were made but eventually=0D=0Aruled out (e.g. =
using BPF for fault handling).=20=0D=0A=0D=0AConcrete requests (demands=3F=
) from the fuse community included the following:=0D=0A- Pass daxdevs int=
o the kernel via an ioctl rather than a new fuse=0D=0A  message/response=0D=
=0A- Lose the famfs interleaved extent format. I have complied with this =
request.=0D=0A  It makes some things worse, but we'll discuss that later.=
=0D=0A=0D=0AThere has also been a desire from the fuse community for famf=
s to use an=0D=0Aexperimental implementation of virtual backing-devs from=
 Darrick. I'm leaving=0D=0Athis out as a potential future optimization - =
although Darrick has announced=0D=0Athat he (and $employer) intend to aba=
ndon that work, so it's not clear whether=0D=0Athat will become viable.=0D=
=0A=0D=0ANOTE: the dax support that famfs requires (devdax fs-dax / fsdev=
) is now in=0D=0Aupstream Linux, so this series no longer depends on a bu=
ndled or out-of-tree=0D=0Adax patch set - it applies on mainline. (It cur=
rently uses the upstream=0D=0Adax_dev_get(); a follow-on will switch to d=
ax_dev_find() once that helper is=0D=0Aupstream too - see "Changes v10 ->=
 v11" below.) There are a few orthogonal=0D=0Afix patches for the devdax =
stack, and one that will trigger a patch to this=0D=0Acode (changing from=
 dax_get_get() to dax_dev_find()). I'll patch this code=0D=0Awhen that fi=
x lands.=0D=0A=0D=0AChanges v10 -> v11=0D=0A- The dax support famfs depen=
ds on is now upstream, so this series no longer=0D=0A  carries or depends=
 on a bundled dax patch set (v10 was based on Ira's=0D=0A  for-7.1/dax-fa=
mfs branch [0]); v11 applies on mainline.=0D=0A- Dropped the controversia=
l famfs interleaved extent format structures from=0D=0A  the ABI.=0D=0A- =
Daxdev acquisition changed from a fuse message to an ioctl. The=0D=0A  GE=
T_DAXDEV message/response (kernel pulls a daxdev by pathname) has been=0D=
=0A  replaced by FUSE_DEV_IOC_DAXDEV_OPEN: the fuse server now pushes eac=
h=0D=0A  daxdev to the kernel by fd, and the kernel resolves it and acqui=
res it=0D=0A  exclusively via fs_dax_get(). This removes the GET_DAXDEV m=
essage plumbing=0D=0A  (patch "famfs_fuse: GET_DAXDEV message and daxdev_=
table" becomes=0D=0A  "fuse: register fs-dax daxdevs via FUSE_DEV_IOC_DAX=
DEV_OPEN").=0D=0A- New patch "famfs_fuse: fail I/O on invalid or errored =
daxdevs": the iomap=0D=0A  resolution path now gates on the state of the =
backing daxdev (slot never=0D=0A  installed, exclusive acquire failed, or=
 a memory error was reported via=0D=0A  notify_failure) and fails the acc=
ess (-EIO / -EHWPOISON) rather than=0D=0A  mapping it.=0D=0A- Removed FUS=
E_FAMFS_MAX_EXTENTS. A GET_FMAP reply is now bounded by the=0D=0A  reply =
buffer size rather than a separate extent-count cap.=0D=0A- Code-review p=
ass over the whole series (self-review of every patch).=0D=0A=0D=0A=0D=0A=
Description:=0D=0A=0D=0AThis patch series introduces famfs into the fuse =
file system framework.=0D=0AThe dax support that famfs relies on is now u=
pstream.=0D=0A=0D=0AThe famfs user space code can be found at [1].=0D=0A=0D=
=0AFuse Overview:=0D=0A=0D=0AFamfs started as a standalone file system, b=
ut this series is intended to=0D=0Apermanently supersede that implementat=
ion. At a high level, famfs adds one=0D=0Anew fuse server message plus on=
e device ioctl:=0D=0A=0D=0AGET_FMAP                 - Retrieves a famfs f=
map (the file-to-dax map for a=0D=0A                           famfs file=
)=0D=0AFUSE_DEV_IOC_DAXDEV_OPEN - The fuse server pushes a daxdev (by fd)=
 that was=0D=0A                           referenced by an fmap, so the k=
ernel can acquire=0D=0A                           it=0D=0A=0D=0AFamfs Ove=
rview=0D=0A=0D=0AFamfs exposes shared memory as a file system. Famfs cons=
umes shared=0D=0Amemory from dax devices, and provides memory-mappable fi=
les that map=0D=0Adirectly to the memory - no page cache involvement. Fam=
fs differs from=0D=0Aconventional file systems in fs-dax mode, in that it=
 handles in-memory=0D=0Ametadata in a sharable way (which begins with nev=
er caching dirty shared=0D=0Ametadata).=0D=0A=0D=0AFamfs started as a sta=
ndalone file system [2,3], but the consensus at=0D=0ALSFMM was that it sh=
ould be ported into fuse [4,5].=0D=0A=0D=0AThe key performance requiremen=
t is that famfs must resolve mapping faults=0D=0Awithout upcalls. This is=
 achieved by fully caching the file-to-devdax=0D=0Ametadata for all activ=
e files. The fmap is retrieved via the GET_FMAP=0D=0Amessage/response; th=
e daxdevs an fmap references are registered by the=0D=0Aserver via the FU=
SE_DEV_IOC_DAXDEV_OPEN ioctl.=0D=0A=0D=0AFamfs remains the first fs-dax f=
ile system that is backed by devdax=0D=0Arather than pmem in fs-dax mode =
(hence the need for the new dax mode).=0D=0A=0D=0ANotes=0D=0A=0D=0A- When=
 a file is opened in a famfs mount, the OPEN is followed by a=0D=0A  GET_=
FMAP message and response. The "fmap" is the full file-to-dax=0D=0A  mapp=
ing, allowing the fuse/famfs kernel code to handle=0D=0A  read/write/faul=
t without any upcalls.=0D=0A=0D=0A- Each fmap is checked for extents that=
 reference previously-unknown=0D=0A  daxdevs. The fuse server registers e=
ach such daxdev with the kernel=0D=0A  via the FUSE_DEV_IOC_DAXDEV_OPEN i=
octl (passing an fd to the devdax=0D=0A  device), rather than the kernel =
pulling it by name.=0D=0A=0D=0A- Daxdevs are stored in a table (which mig=
ht become an xarray at some=0D=0A  point). When entries are added to the =
table, we acquire exclusive=0D=0A  access to the daxdev via the fs_dax_ge=
t() call (modeled after how=0D=0A  fs-dax handles this with pmem devices)=
=2E Famfs provides=0D=0A  holder_operations to devdax, providing a notifi=
cation path in the=0D=0A  event of memory errors or forced reconfiguratio=
n.=0D=0A=0D=0A- If devdax notifies famfs of memory errors on a dax device=
, famfs=0D=0A  currently blocks all subsequent accesses to data on that d=
evice. The=0D=0A  recovery is to re-initialize the memory and file system=
=2E Famfs is=0D=0A  memory, not storage...=0D=0A=0D=0A- Because famfs use=
s backing (devdax) devices, only privileged mounts are=0D=0A  supported (=
i.e. the fuse server requires CAP_SYS_RAWIO).=0D=0A=0D=0A- The famfs kern=
el code never accesses the memory directly - it only=0D=0A  facilitates r=
ead, write and mmap on behalf of user processes, using=0D=0A  fmap metada=
ta provided by its privileged fuse server. As such, the=0D=0A  RAS of the=
 shared memory affects applications, but not the kernel.=0D=0A=0D=0A- Fam=
fs has backing device(s), but they are devdax (char) rather than=0D=0A  b=
lock. Right now there is no way to tell the vfs layer that famfs has a=0D=
=0A  char backing device (unless we say it's block, but it's not). Curren=
tly=0D=0A  we use the standard anonymous fuse fs_type - but I'm not sure =
that's=0D=0A  ultimately optimal (thoughts=3F)=0D=0A=0D=0AChanges v9 -> v=
10=0D=0A- Rebased to Ira's for-7.1/dax-famfs branch [0], which contains t=
he required=0D=0A  dax patches=0D=0A- Add parentheses to FUSE_IS_VIRTIO_D=
AX() macro, in case something bad is=0D=0A  passed in as fuse_inode (than=
ks Jonathan's AI)=0D=0A=0D=0AChanges v8 -> v9=0D=0A- Kconfig: fs/fuse/Kco=
nfig:CONFIG_FUSE_FAMFS_DAX now depends on the=0D=0A  new CONFIG_DEV_DAX_F=
SDEV (from drivers/dax/Kconfig) rather than=0D=0A  just CONFIG_DEV_DAX an=
d CONFIG_FS_DAX. (CONFIG_FUSE_FAMFS_DAX=0D=0A  depends on those...)=0D=0A=
=0D=0AChanges v7 -> v8=0D=0A- Moved to inline __free declaration in fuse_=
get_fmap() and=0D=0A  famfs_fuse_meta_alloc(), famfs_teardown()=0D=0A- Ad=
opted FIELD_PREP() macro rather than manual bitfield manipulation=0D=0A- =
Minor doc edits=0D=0A- I dropped adding magic numbers to include/uapi/lin=
ux/magic.h. That=0D=0A  can be done later if appropriate=0D=0A=0D=0AChang=
es v6 -> v7=0D=0A- Fixed a regression in famfs_interleave_fileofs_to_daxo=
fs() that=0D=0A  was reported by Intel's kernel test robot=0D=0A- Added a=
 check in __fsdev_dax_direct_access() for negative return=0D=0A  from pgo=
ff_to_phys(), which would indicate an out-of-range offset=0D=0A- Fixed a =
bug in __famfs_meta_free(), where not all interleaved=0D=0A  extents were=
 freed=0D=0A- Added chunksize alignment checks in famfs_fuse_meta_alloc()=
 and=0D=0A  famfs_interleave_fileofs_to_daxofs() as interleaved chunks mu=
st=0D=0A  be PTE or PMD aligned=0D=0A- Simplified famfs_file_init_dax() a=
 bit=0D=0A- Re-ran CM's kernel code review prompts on the entire series a=
nd=0D=0A  fixed several minor issues=0D=0A=0D=0AChanges v4 -> v5 -> v6=0D=
=0A- None. Re-sending due to technical difficulties=0D=0A=0D=0AChanges v3=
 [9] -> v4=0D=0A- The patch "dax: prevent driver unbind while filesystem =
holds device"=0D=0A  has been dropped. Dan Williams indicated that the fa=
vored behavior is=0D=0A  for a file system to stop working if an underlyi=
ng driver is unbound,=0D=0A  rather than preventing the unbind.=0D=0A- Th=
e patch "famfs_fuse: Famfs mount opt: -o shadow=3D<shadowpath>" has=0D=0A=
  been dropped. Found a way for the famfs user space to do without the=0D=
=0A  -o opt (via getxattr).=0D=0A- Squashed the fs/fuse/Kconfig patch int=
o the first subsequent patch=0D=0A  that needed the change=0D=0A  ("famfs=
_fuse: Basic fuse kernel ABI enablement for famfs")=0D=0A- Many review co=
mments addressed.=0D=0A- Addressed minor kerneldoc infractions reported b=
y test robot.=0D=0A=0D=0AChanges v2 [7] -> v3=0D=0A- Dax: Completely new =
fsdev driver (drivers/dax/fsdev.c) replaces the=0D=0A  dev_dax_iomap modi=
fications to bus.c/device.c. Devdax devices can now=0D=0A  be switched am=
ong 'devdax', 'famfs' and 'system-ram' modes via daxctl=0D=0A  or sysfs.=0D=
=0A- Dax: fsdev uses MEMORY_DEVICE_FS_DAX type and leaves folios at order=
-0=0D=0A  (no vmemmap_shift), allowing fs-dax to manage folio lifecycles=0D=
=0A  dynamically like pmem does.=0D=0A- Dax: The "poisoned page" problem =
is properly fixed via=0D=0A  fsdev_clear_folio_state(), which clears stal=
e mapping/compound state=0D=0A  when fsdev binds. The temporary WARN_ON_O=
NCE workaround in fs/dax.c=0D=0A  has been removed.=0D=0A- Dax: Added dax=
_set_ops() so fsdev can set dax_operations at bind time=0D=0A  (and clear=
 them on unbind), since the dax_device is created before we=0D=0A  know w=
hich driver will bind.=0D=0A- Dax: Added custom bind/unbind sysfs handler=
s; unbind return -EBUSY if a=0D=0A  filesystem holds the device, preventi=
ng unbind while famfs is mounted.=0D=0A- Fuse: Famfs mounts now require t=
hat the fuse server/daemon has=0D=0A  CAP_SYS_RAWIO because they expose r=
aw memory devices.=0D=0A- Fuse: Added DAX address_space_operations with n=
oop_dirty_folio since=0D=0A  famfs is memory-backed with no writeback req=
uired.=0D=0A- Rebased to latest kernels, fully compatible with Alistair P=
opple=0D=0A  et. al's recent dax refactoring.=0D=0A- Ran this series thro=
ugh Chris Mason's code review AI prompts to check=0D=0A  for issues - sev=
eral subtle problems found and fixed.=0D=0A- Dropped RFC status - this ve=
rsion is intended to be mergeable.=0D=0A=0D=0AChanges v1 [8] -> v2:=0D=0A=
=0D=0A- The GET_FMAP message/response has been moved from LOOKUP to OPEN,=
 as=0D=0A  was the pretty much unanimous consensus.=0D=0A- Made the respo=
nse payload to GET_FMAP variable sized (patch 12)=0D=0A- Dodgy kerneldoc =
comments cleaned up or removed.=0D=0A- Fixed memory leak of fc->shadow in=
 patch 11 (thanks Joanne)=0D=0A- Dropped many pr_debug and pr_notice call=
s=0D=0A=0D=0A=0D=0AReferences=0D=0A=0D=0A[0] - https://git.kernel.org/pub=
/scm/linux/kernel/git/nvdimm/nvdimm.git/=0D=0A[1] - https://famfs.org (fa=
mfs user space)=0D=0A[2] - https://lore.kernel.org/linux-cxl/cover.170870=
9155.git.john@groves.net/=0D=0A[3] - https://lore.kernel.org/linux-cxl/co=
ver.1714409084.git.john@groves.net/=0D=0A[4] - https://lwn.net/Articles/9=
83105/ (lsfmm 2024)=0D=0A[5] - https://lwn.net/Articles/1020170/ (lsfmm 2=
025)=0D=0A[6] - https://lore.kernel.org/linux-cxl/cover.8068ad144a7eea4a8=
13670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvidia.com/=0D=0A[7=
] - https://lore.kernel.org/linux-fsdevel/20250703185032.46568-1-john@gro=
ves.net/ (famfs fuse v2)=0D=0A[8] - https://lore.kernel.org/linux-fsdevel=
/20250421013346.32530-1-john@groves.net/ (famfs fuse v1)=0D=0A[9] - https=
://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-john@groves.net/T=
/#mb2c868801be16eca82dab239a1d201628534aea7 (famfs fuse v3)=0D=0A[10] - [=
TODO: John - famfs fuse v10 lore link]=0D=0A=0D=0A=0D=0AJohn Groves (9):=0D=
=0A  famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/=0D=0A  fa=
mfs_fuse: Basic fuse kernel ABI enablement for famfs=0D=0A  famfs_fuse: P=
lumb the GET_FMAP message/response=0D=0A  famfs_fuse: Create files with f=
amfs fmaps=0D=0A  famfs_fuse: register fs-dax daxdevs via FUSE_DEV_IOC_DA=
XDEV_OPEN=0D=0A  famfs_fuse: Plumb dax iomap and fuse read/write/mmap=0D=0A=
  famfs_fuse: fail I/O on invalid or errored daxdevs=0D=0A  famfs_fuse: A=
dd DAX address_space_operations with noop_dirty_folio=0D=0A  famfs_fuse: =
Add documentation=0D=0A=0D=0A Documentation/filesystems/famfs.rst |  143 =
++++=0D=0A Documentation/filesystems/index.rst |    1 +=0D=0A MAINTAINERS=
                         |    9 +=0D=0A fs/fuse/Kconfig                  =
   |   13 +=0D=0A fs/fuse/Makefile                    |    1 +=0D=0A fs/f=
use/dev.c                       |   31 +=0D=0A fs/fuse/dev.h             =
          |    1 +=0D=0A fs/fuse/dir.c                       |    2 +-=0D=
=0A fs/fuse/famfs.c                     | 1066 ++++++++++++++++++++++++++=
+=0D=0A fs/fuse/famfs_kfmap.h               |   91 +++=0D=0A fs/fuse/file=
=2Ec                      |   48 +-=0D=0A fs/fuse/fuse_i.h               =
     |  125 +++-=0D=0A fs/fuse/inode.c                     |   35 +-=0D=0A=
 fs/fuse/iomode.c                    |    2 +-=0D=0A include/uapi/linux/f=
use.h           |   55 +-=0D=0A 15 files changed, 1608 insertions(+), 15 =
deletions(-)=0D=0A create mode 100644 Documentation/filesystems/famfs.rst=
=0D=0A create mode 100644 fs/fuse/famfs.c=0D=0A create mode 100644 fs/fus=
e/famfs_kfmap.h=0D=0A=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
