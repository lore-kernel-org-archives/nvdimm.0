Received: from a11-79.smtp-out.amazonses.com (a11-79.smtp-out.amazonses.com [54.240.11.79])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839BA39479B;
	Mon, 20 Jul 2026 03:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519225; cv=none; b=Vt+azr7MXusReg/QBgkfQIm+ZuvRQZhpbUuFi9gcbJef76GLjkd/fS4hyswN363Ct453GwG5wtXNJWkqIjmEFRhuy1hEenPl+wDxxdbFO1LgBS0kFsPiVgM2N9niNuT0uWfQjyPqiMFVAhHAdmDHj/MijnnuyDiXILa0qc6YfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519225; c=relaxed/simple;
	bh=AKOQvCU1SioN6AlWTyX+BY+NjVyvfhDuKequOW2UlYc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=QezJFRThh+W8uMxPJoz9+WhwgRH0Tb9z6LaYQfrBi39SzLbO1ZaSG9s+oJnyfcmDy3fGc7EqFQMIz1KzyufitmwHZVqDCyEP2CwBoCNq4iZwb/wfnN9c61sJc8oVPLmURALnLzNAoQ5+kxREcaIR34S7/Mv8Ekf1G9++qWs1tNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=a6GuTkyx; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=P6ArKtqU; arc=none smtp.client-ip=54.240.11.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="a6GuTkyx";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="P6ArKtqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519222;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=AKOQvCU1SioN6AlWTyX+BY+NjVyvfhDuKequOW2UlYc=;
	b=a6GuTkyxiexDLXZ+SSvuxvn+efO06HLyUZNAzJjpEF+oBj/m7JKeB/RqJ0j7fjAQ
	gVGXMVAHNKWJvbnQ0Xr7rM9QXrOx75wETi74VWgBA37OB6d17qYyEfKZ7fWFGHCOzNN
	B+GykwvWHWpTdD8wQWcTMjQkLhKQUlos1+jShCvQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519222;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=AKOQvCU1SioN6AlWTyX+BY+NjVyvfhDuKequOW2UlYc=;
	b=P6ArKtqU+5Ju4AbqnfpZ3RzUm3CoGevGb9hT0OSfIQk35dQPHrSE8tJnAWqKMOmx
	XNtEoxVseQ1xrrSTDbW+loHnazEWhwJsWTaIAPHLo+nbJ+C1UuvOdNMGG05il2b0bX0
	nV1tRtITzCa9zwmQdlxqdBVHfV1M0+detA+M1j0s=
Subject: [PATCH V11 9/9] famfs_fuse: Add documentation
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Mon, 20 Jul 2026 03:47:02 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
References: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com> 
 <20260720034650.68894-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAGd/W
Thread-Topic: [PATCH V11 9/9] famfs_fuse: Add documentation
X-Wm-Sent-Timestamp: 1784519220
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da26385-94d6fb3e-9702-47b4-bad1-9529eb7c4b5b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.79

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd Documentation/filesyst=
ems/famfs.rst and update MAINTAINERS=0D=0A=0D=0AReviewed-by: Randy Dunlap=
 <rdunlap@infradead.org>=0D=0ATested-by: Randy Dunlap <rdunlap@infradead.=
org>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A Documentation=
/filesystems/famfs.rst | 143 ++++++++++++++++++++++++++++=0D=0A Documenta=
tion/filesystems/index.rst |   1 +=0D=0A MAINTAINERS                     =
    |   1 +=0D=0A 3 files changed, 145 insertions(+)=0D=0A create mode 10=
0644 Documentation/filesystems/famfs.rst=0D=0A=0D=0Adiff --git a/Document=
ation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst=0D=0Ane=
w file mode 100644=0D=0Aindex 000000000000..2b4a2269ef55=0D=0A--- /dev/nu=
ll=0D=0A+++ b/Documentation/filesystems/famfs.rst=0D=0A@@ -0,0 +1,143 @@=0D=
=0A+.. SPDX-License-Identifier: GPL-2.0=0D=0A+=0D=0A+.. _famfs_index:=0D=0A=
+=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+famfs: Th=
e fabric-attached memory file system=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+- Copyright (C) 2024-2026 Micron Technolo=
gy, Inc.=0D=0A+=0D=0A+Introduction=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=0D=0A+Compute Express Link (CXL) provides a mechanism for disaggregat=
ed or=0D=0A+fabric-attached memory (FAM). This creates opportunities for =
data sharing;=0D=0A+clustered apps that would otherwise have to shard or =
replicate data can=0D=0A+share one copy in disaggregated memory.=0D=0A+=0D=
=0A+Famfs, which is not CXL-specific in any way, provides a mechanism for=
=0D=0A+multiple hosts to concurrently access data in shared memory, by gi=
ving it=0D=0A+a file system interface. With famfs, any app that understan=
ds files can=0D=0A+access data sets in shared memory. Although famfs supp=
orts read and write,=0D=0A+the real point is to support mmap, which provi=
des direct (dax) access to=0D=0A+the memory - either writable or read-onl=
y.=0D=0A+=0D=0A+Shared memory can pose complex coherency and synchronizat=
ion issues, but=0D=0A+there are also simple cases. Two simple and eminent=
ly useful patterns that=0D=0A+occur frequently in data analytics and AI a=
re:=0D=0A+=0D=0A+* Serial Sharing - Only one host or process at a time ha=
s access to a file=0D=0A+* Read-only Sharing - Multiple hosts or processe=
s share read-only access=0D=0A+  to a file=0D=0A+=0D=0A+The famfs fuse fi=
le system is part of the famfs framework; user space=0D=0A+components [1]=
 handle metadata allocation and distribution, and provide a=0D=0A+low-lev=
el fuse server to expose files that map directly to [presumably=0D=0A+sha=
red] memory.=0D=0A+=0D=0A+The famfs framework manages coherency of its ow=
n metadata and structures,=0D=0A+but does not attempt to manage coherency=
 for applications.=0D=0A+=0D=0A+Famfs also provides data isolation betwee=
n files. That is, even though=0D=0A+the host has access to an entire memo=
ry "device" (as a devdax device), apps=0D=0A+cannot write to memory for w=
hich the file is read-only, and mapping one=0D=0A+file provides isolation=
 from the memory of all other files. This is pretty=0D=0A+basic, but some=
 experimental shared memory usage patterns provide no such=0D=0A+isolatio=
n.=0D=0A+=0D=0A+Principles of Operation=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Famfs is a file s=
ystem with one or more devdax devices as a first-class=0D=0A+backing devi=
ce(s). Metadata maintenance and query operations happen=0D=0A+entirely in=
 user space.=0D=0A+=0D=0A+The famfs low-level fuse server daemon provides=
 file maps (fmaps) and=0D=0A+devdax device info to the fuse/famfs kernel =
component so that=0D=0A+read/write/mapping faults can be handled without =
up-calls for all active=0D=0A+files.=0D=0A+=0D=0A+The famfs user space is=
 responsible for maintaining and distributing=0D=0A+consistent metadata. =
This is currently handled via an append-only=0D=0A+metadata log within th=
e memory, but this is orthogonal to the fuse/famfs=0D=0A+kernel code.=0D=0A=
+=0D=0A+Once instantiated, "the same file" on each host points to the sam=
e shared=0D=0A+memory, but in-memory metadata (inodes, etc.) is ephemeral=
 on each host=0D=0A+that has a famfs instance mounted. Use cases are free=
 to allow or not=0D=0A+allow mutations to data on a file-by-file basis.=0D=
=0A+=0D=0A+When an app accesses a data object in a famfs file, there is n=
o page cache=0D=0A+involvement. The CPU cache is loaded directly from the=
 shared memory. In=0D=0A+some use cases, this is an enormous reduction in=
 read amplification=0D=0A+compared to loading an entire page into the pag=
e cache.=0D=0A+=0D=0A+=0D=0A+Famfs is Not a Conventional File System=0D=0A=
+---------------------------------------=0D=0A+=0D=0A+Famfs files can be =
accessed by conventional means, but there are=0D=0A+limitations. The kern=
el component of fuse/famfs is not involved in the=0D=0A+allocation of bac=
king memory for files at all; the famfs user space=0D=0A+creates files an=
d responds as a low-level fuse server with fmaps and=0D=0A+devdax device =
info upon request.=0D=0A+=0D=0A+Famfs differs in some important ways from=
 conventional file systems:=0D=0A+=0D=0A+* Files must be pre-allocated by=
 the famfs framework; allocation is never=0D=0A+  performed on (or after)=
 write.=0D=0A+* Any operation that changes a file's size is considered to=
 put the file=0D=0A+  in an invalid state, disabling access to the data. =
It may be possible to=0D=0A+  revisit this in the future. (Typically the =
famfs user space can restore=0D=0A+  files to a valid state by replaying =
the famfs metadata log.)=0D=0A+=0D=0A+Famfs exists to apply the existing =
file system abstractions to shared=0D=0A+memory so applications and workf=
lows can more easily adapt to an=0D=0A+environment with disaggregated sha=
red memory.=0D=0A+=0D=0A+Memory Error Handling=0D=0A+=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Possible memory e=
rrors include timeouts, poison, and unexpected=0D=0A+reconfiguration of a=
n underlying dax device. In all of these cases, famfs=0D=0A+receives a ca=
ll from the devdax layer via its=0D=0A+dax_holder_operations->notify_fail=
ure() function. If any memory errors have=0D=0A+been detected, access to =
the affected=0D=0A+daxdev is disabled to avoid further errors or corrupti=
on.=0D=0A+=0D=0A+In all known cases, famfs can be unmounted cleanly. In m=
ost cases errors=0D=0A+can be cleared by re-initializing the memory - at =
which point a new famfs=0D=0A+file system can be created.=0D=0A+=0D=0A+Ke=
y Requirements=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A=
+=0D=0A+The primary requirements for famfs are:=0D=0A+=0D=0A+1. Must supp=
ort a file system abstraction backed by sharable devdax memory=0D=0A+2. F=
iles must efficiently handle VMA faults=0D=0A+3. Must support metadata di=
stribution in a sharable way=0D=0A+4. Must handle clients with a stale co=
py of metadata=0D=0A+=0D=0A+The famfs kernel component takes care of 1-2 =
above by caching each file's=0D=0A+mapping metadata in the kernel.=0D=0A+=
=0D=0A+Requirements 3 and 4 are handled by the user space components, and=
 are=0D=0A+largely orthogonal to the functionality of the famfs kernel mo=
dule.=0D=0A+=0D=0A+Requirements 3 and 4 cannot be met by conventional fs-=
dax file systems=0D=0A+(e.g. xfs) because they use write-back metadata; i=
t is not valid to mount=0D=0A+such a file system on two hosts from the sa=
me in-memory image.=0D=0A+=0D=0A+=0D=0A+Famfs Usage=0D=0A+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Famfs usage is documented at [1].=0D=0A+=0D=
=0A+=0D=0A+References=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+-=
 [1] Famfs user space repository and documentation=0D=0A+      https://gi=
thub.com/cxl-micron-reskit/famfs=0D=0Adiff --git a/Documentation/filesyst=
ems/index.rst b/Documentation/filesystems/index.rst=0D=0Aindex 1f71cf1595=
47..97a9a1f1e96a 100644=0D=0A--- a/Documentation/filesystems/index.rst=0D=
=0A+++ b/Documentation/filesystems/index.rst=0D=0A@@ -91,6 +91,7 @@ Docum=
entation for filesystem implementations.=0D=0A    ext3=0D=0A    ext4/inde=
x=0D=0A    f2fs=0D=0A+   famfs=0D=0A    gfs2/index=0D=0A    hfs=0D=0A    =
hfsplus=0D=0Adiff --git a/MAINTAINERS b/MAINTAINERS=0D=0Aindex 07db3a5a2a=
f7..1477b66f4450 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A=
@@ -10718,6 +10718,7 @@ M:=09John Groves <John@Groves.net>=0D=0A L:=09lin=
ux-cxl@vger.kernel.org=0D=0A L:=09linux-fsdevel@vger.kernel.org=0D=0A S:=09=
Supported=0D=0A+F:=09Documentation/filesystems/famfs.rst=0D=0A F:=09fs/fu=
se/famfs.c=0D=0A F:=09fs/fuse/famfs_kfmap.h=0D=0A=20=0D=0A--=20=0D=0A2.53=
=2E0=0D=0A=0D=0A
