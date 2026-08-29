Received: from a11-127.smtp-out.amazonses.com (a11-127.smtp-out.amazonses.com [54.240.11.127])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880763F8893;
	Sat, 29 Aug 2026 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023606; cv=none; b=o68npjfRXz2aC6DefBUo/02ZfJ49KHaMWNpWVTYTt8qq2VcUmVL4X5Zmyxu0n3APD/FaOz4H9jvtOcwiuHRg8gsVEWhU6kyxoYym5TiLZdRBCW/VzELRvZKM0wA8mAn4ACXdb7LZ8DENfiktLh7xzypkRhtxQVHQ4deC8XFXa6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023606; c=relaxed/simple;
	bh=1hTdEQvbjrgWTg8L2D6TFiHhycnEwzxEVaO9WRFhRWw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=enNBX5KMQzmixTQmEqCqIed0HRzHNb2Qcbzxj0O8OJI/qLVYcVWkO6n0HdR7IIenu6AzYQ2TB+KrdsqiVfqFY1Dx55KqyVESP8djs6MhUa05t5s6pn4PibtXfTuHaiABpCs1Xv3SXd9Uw14qsMtFCSsfw1hLovb7en6DNL5Klg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=LG6QgSzP; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=flmyZaK6; arc=none smtp.client-ip=54.240.11.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="LG6QgSzP";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="flmyZaK6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023603;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=1hTdEQvbjrgWTg8L2D6TFiHhycnEwzxEVaO9WRFhRWw=;
	b=LG6QgSzPDDJSgm+1+xxqIKLOYFzM0uUUJFptKP+rqB7eo/UvkIcDpgda1tlTpdxw
	ioYDJxmtTzIQUvr35cgEwdlWy+nazRE51etOm+IhNaTYdUcadccJpaa6W9/gz9XtlG6
	nQXxUjxYJJDHC/jvAxOjEtp4e7hwri3ncKRz2lec=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023603;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=1hTdEQvbjrgWTg8L2D6TFiHhycnEwzxEVaO9WRFhRWw=;
	b=flmyZaK6GTrZeraVVj9o5Q21Krle4MKDn7r1TWtIytdgW3PJeLDWQKf/H5PhINWQ
	meAEwBWhRioPsDWKTdYbY3BW3bBG/Q9U/Vx17q5dlT9FJX/WbFISiyVFTdPJI2ByZ8R
	2sdyUfyB+2EJFQO2/GPUVn1pN8h5EAsETb7p7wtg=
Subject: [PATCH V14 12/12] famfs: Add documentation
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Jake_Edge?= <jake@lwn.net>, 
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
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
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
	=?UTF-8?Q?Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Pasha_Tatashin?= <pasha.tatashin@soleen.com>, 
	=?UTF-8?Q?Haren_Myneni?= <haren@linux.ibm.com>, 
	=?UTF-8?Q?Pratyush_Yadav?= <pratyush@kernel.org>, 
	=?UTF-8?Q?Giovanni_Cabiddu?= <giovanni.cabiddu@intel.com>, 
	=?UTF-8?Q?Jiri_Slaby?= <jirislaby@kernel.org>, 
	=?UTF-8?Q?Ethan_Nelson-Moo?= =?UTF-8?Q?re?= <enelsonmoore@gmail.com>, 
	=?UTF-8?Q?Gabriel_Whigham?= <gabewhigham@gmail.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40m?= =?UTF-8?Q?icron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40?= =?UTF-8?Q?vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 29 Aug 2026 17:13:23 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
References: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com> 
 <20260829171317.7551-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAAHF0l
Thread-Topic: [PATCH V14 12/12] famfs: Add documentation
X-Wm-Sent-Timestamp: 1788023602
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e83009f-d8fd0bf4-337f-4420-a73d-780df3cc27af-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.127

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd Documentation/filesyst=
ems/famfs.rst and update MAINTAINERS=0D=0A=0D=0AReviewed-by: Randy Dunlap=
 <rdunlap@infradead.org>=0D=0ATested-by: Randy Dunlap <rdunlap@infradead.=
org>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0A=
=0D=0AReviewed-by: "Darrick J. Wong" <djwong@kernel.org>=0D=0AReviewed-by=
: Jeff Layton <jlayton@kernel.org>=0D=0ASigned-off-by: John Groves <john@=
groves.net>=0D=0A---=0D=0A Documentation/filesystems/famfs.rst | 142 ++++=
++++++++++++++++++++++++=0D=0A Documentation/filesystems/index.rst |   1 =
+=0D=0A MAINTAINERS                         |   1 +=0D=0A 3 files changed=
, 144 insertions(+)=0D=0A create mode 100644 Documentation/filesystems/fa=
mfs.rst=0D=0A=0D=0Adiff --git a/Documentation/filesystems/famfs.rst b/Doc=
umentation/filesystems/famfs.rst=0D=0Anew file mode 100644=0D=0Aindex 000=
000000000..048791bcbcfd=0D=0A--- /dev/null=0D=0A+++ b/Documentation/files=
ystems/famfs.rst=0D=0A@@ -0,0 +1,142 @@=0D=0A+.. SPDX-License-Identifier:=
 GPL-2.0=0D=0A+=0D=0A+.. _famfs_index:=0D=0A+=0D=0A+=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+famfs: The fabric-attached memory file =
system=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=
=0A+- Copyright (C) 2024-2026 Micron Technology, Inc.=0D=0A+=0D=0A+Introd=
uction=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+Compute Express L=
ink (CXL) provides a mechanism for disaggregated or=0D=0A+fabric-attached=
 memory (FAM). This creates opportunities for data sharing;=0D=0A+cluster=
ed apps that would otherwise have to shard or replicate data can=0D=0A+sh=
are one copy in disaggregated memory.=0D=0A+=0D=0A+Famfs, which is not CX=
L-specific in any way, provides a mechanism for=0D=0A+multiple hosts to c=
oncurrently access data in shared memory, by giving it=0D=0A+a file syste=
m interface. With famfs, any app that understands files can=0D=0A+access =
data sets in shared memory. Although famfs supports read and write,=0D=0A=
+the real point is to support mmap, which provides direct (dax) access to=
=0D=0A+the memory - either writable or read-only.=0D=0A+=0D=0A+Shared mem=
ory can pose complex coherency and synchronization issues, but=0D=0A+ther=
e are also simple cases. Two simple and eminently useful patterns that=0D=
=0A+occur frequently in data analytics and AI are:=0D=0A+=0D=0A+* Serial =
Sharing - Only one host or process at a time has access to a file=0D=0A+*=
 Read-only Sharing - Multiple hosts or processes share read-only access=0D=
=0A+  to a file=0D=0A+=0D=0A+The famfs file system is part of the famfs f=
ramework; user space=0D=0A+components [1] handle metadata allocation and =
distribution, and populate=0D=0A+the in-kernel files (via ioctls) so that=
 they map directly to shared=0D=0A+memory.=0D=0A+=0D=0A+The famfs framewo=
rk manages coherency of its own metadata and structures,=0D=0A+but does n=
ot attempt to manage coherency for applications.=0D=0A+=0D=0A+Famfs also =
provides data isolation between files. That is, even though=0D=0A+the hos=
t has access to an entire memory "device" (as a devdax device), apps=0D=0A=
+cannot write to memory for which the file is read-only, and mapping one=0D=
=0A+file provides isolation from the memory of all other files. This is p=
retty=0D=0A+basic, but some experimental shared memory usage patterns pro=
vide no such=0D=0A+isolation.=0D=0A+=0D=0A+Principles of Operation=0D=0A+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A=
+=0D=0A+Famfs is a file system with one or more devdax devices as a first=
-class=0D=0A+backing device(s). Metadata maintenance and query operations=
 happen=0D=0A+entirely in user space.=0D=0A+=0D=0A+The famfs user space p=
rovides each file's map (fmap) and its backing=0D=0A+devdax devices to th=
e kernel through ioctls (FAMFSIOC_MAP_CREATE and=0D=0A+FAMFSIOC_DAXDEV_OP=
EN), after which read/write/mapping faults are handled=0D=0A+entirely in =
the kernel with no up-calls for all active files.=0D=0A+=0D=0A+The famfs =
user space is responsible for maintaining and distributing=0D=0A+consiste=
nt metadata. This is currently handled via an append-only=0D=0A+metadata =
log within the memory, but this is orthogonal to the famfs=0D=0A+kernel c=
ode.=0D=0A+=0D=0A+Once instantiated, "the same file" on each host points =
to the same shared=0D=0A+memory, but in-memory metadata (inodes, etc.) is=
 ephemeral on each host=0D=0A+that has a famfs instance mounted. Use case=
s are free to allow or not=0D=0A+allow mutations to data on a file-by-fil=
e basis.=0D=0A+=0D=0A+When an app accesses a data object in a famfs file,=
 there is no page cache=0D=0A+involvement. The CPU cache is loaded direct=
ly from the shared memory. In=0D=0A+some use cases, this is an enormous r=
eduction in read amplification=0D=0A+compared to loading an entire page i=
nto the page cache.=0D=0A+=0D=0A+=0D=0A+Famfs is Not a Conventional File =
System=0D=0A+---------------------------------------=0D=0A+=0D=0A+Famfs f=
iles can be accessed by conventional means, but there are=0D=0A+limitatio=
ns. The famfs kernel module is not involved in the allocation of=0D=0A+ba=
cking memory for files at all; the famfs user space creates files and=0D=0A=
+supplies their fmaps and devdax device info to the kernel via ioctls.=0D=
=0A+=0D=0A+Famfs differs in some important ways from conventional file sy=
stems:=0D=0A+=0D=0A+* Files must be pre-allocated by the famfs framework;=
 allocation is never=0D=0A+  performed on (or after) write.=0D=0A+* Any o=
peration that changes a file's size is considered to put the file=0D=0A+ =
 in an invalid state, disabling access to the data. It may be possible to=
=0D=0A+  revisit this in the future. (Typically the famfs user space can =
restore=0D=0A+  files to a valid state by replaying the famfs metadata lo=
g.)=0D=0A+=0D=0A+Famfs exists to apply the existing file system abstracti=
ons to shared=0D=0A+memory so applications and workflows can more easily =
adapt to an=0D=0A+environment with disaggregated shared memory.=0D=0A+=0D=
=0A+Memory Error Handling=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Possible memory errors include timeout=
s, poison, and unexpected=0D=0A+reconfiguration of an underlying dax devi=
ce. In all of these cases, famfs=0D=0A+receives a call from the devdax la=
yer via its=0D=0A+dax_holder_operations->notify_failure() function. If an=
y memory errors have=0D=0A+been detected, access to the affected=0D=0A+da=
xdev is disabled to avoid further errors or corruption.=0D=0A+=0D=0A+In a=
ll known cases, famfs can be unmounted cleanly. In most cases errors=0D=0A=
+can be cleared by re-initializing the memory - at which point a new famf=
s=0D=0A+file system can be created.=0D=0A+=0D=0A+Key Requirements=0D=0A+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+The primary re=
quirements for famfs are:=0D=0A+=0D=0A+1. Must support a file system abst=
raction backed by sharable devdax memory=0D=0A+2. Files must efficiently =
handle VMA faults=0D=0A+3. Must support metadata distribution in a sharab=
le way=0D=0A+4. Must handle clients with a stale copy of metadata=0D=0A+=0D=
=0A+The famfs kernel component takes care of 1-2 above by caching each fi=
le's=0D=0A+mapping metadata in the kernel.=0D=0A+=0D=0A+Requirements 3 an=
d 4 are handled by the user space components, and are=0D=0A+largely ortho=
gonal to the functionality of the famfs kernel module.=0D=0A+=0D=0A+Requi=
rements 3 and 4 cannot be met by conventional fs-dax file systems=0D=0A+(=
e.g. xfs) because they use write-back metadata; it is not valid to mount=0D=
=0A+such a file system on two hosts from the same in-memory image.=0D=0A+=
=0D=0A+=0D=0A+Famfs Usage=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=
=0A+Famfs usage is documented at [1].=0D=0A+=0D=0A+=0D=0A+References=0D=0A=
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+- [1] Famfs user space repos=
itory and documentation=0D=0A+      https://github.com/cxl-micron-reskit/=
famfs=0D=0Adiff --git a/Documentation/filesystems/index.rst b/Documentati=
on/filesystems/index.rst=0D=0Aindex 1f71cf159547..97a9a1f1e96a 100644=0D=0A=
--- a/Documentation/filesystems/index.rst=0D=0A+++ b/Documentation/filesy=
stems/index.rst=0D=0A@@ -91,6 +91,7 @@ Documentation for filesystem imple=
mentations.=0D=0A    ext3=0D=0A    ext4/index=0D=0A    f2fs=0D=0A+   famf=
s=0D=0A    gfs2/index=0D=0A    hfs=0D=0A    hfsplus=0D=0Adiff --git a/MAI=
NTAINERS b/MAINTAINERS=0D=0Aindex bfc3acf72c9c..515a3d832397 100644=0D=0A=
--- a/MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -9901,6 +9901,7 @@ M:=09=
John Groves <John@Groves.net>=0D=0A L:=09linux-fsdevel@vger.kernel.org=0D=
=0A L:=09linux-cxl@vger.kernel.org=0D=0A S:=09Supported=0D=0A+F:=09Docume=
ntation/filesystems/famfs.rst=0D=0A F:=09fs/famfs/=0D=0A=20=0D=0A FANOTIF=
Y=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
