Received: from a11-80.smtp-out.amazonses.com (a11-80.smtp-out.amazonses.com [54.240.11.80])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E656A34EF03;
	Mon, 10 Aug 2026 20:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393572; cv=none; b=RwxJWiGaNYaUyoI3zSOarmdLbT9kkrJ7R+TfOzYMXsRGPM/Q5+z7UdZaV1bCOAseMQ1EbKl+d2Gi/JKy5Ly3EYLfneHgax8CJ8BLcyvuTSIGs8POSJDcnlXH5czTUr4LdJLlkOYkDpGuOPF8l6n/oqD5SwaJRE2r1dfIWO9YPXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393572; c=relaxed/simple;
	bh=jlzaWT67ROlF0vfbvokOde288YAFHqOzVK71vsJxpdg=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=C28cpEtTWS3rhwXj+eVuGbqIchqr7heS5U9Iavji7czLBwe3APWRIwhW5ATSph2CXSW2uoTmC2aY3T6PiplE0p+Wdbq7MJdiwmmcDgqfCNANga7onxW324vpGuzicrv+rV86P3Fr/rsSkMXpOjWzHdlqeNamJQgN2V9MS0ZG89I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=lGS9I+AT; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ifS33NOT; arc=none smtp.client-ip=54.240.11.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="lGS9I+AT";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ifS33NOT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393569;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=jlzaWT67ROlF0vfbvokOde288YAFHqOzVK71vsJxpdg=;
	b=lGS9I+ATknj9B1YCRSvnciUiZKSNweGCxe32f0LROMEHN3xP/SrfWEsdAvrsLHIF
	iG3yP50CAmfIMIz3qV5yj/YQiSA33W9UKRy1Uf51eaiXr1Eg2nfQQyRVHSbua37DYI3
	GmIiqs28CcYck8GThPMJW035AUgNHnuQ3zMEXQIo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393569;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=jlzaWT67ROlF0vfbvokOde288YAFHqOzVK71vsJxpdg=;
	b=ifS33NOTfcs6ck4PCf6QQr5PXxApjrbMC9lx8HuEbWV7xZCJxjip9IhJXQr+4g7Q
	2/unBRkeA9N2cj03zaXj+bDrGErpbcN6r6xoBqdpyCSIgz99pNFw1cD3QmCU4Rt0z88
	xXL107PYC+HiCaiavirbq/ZidMELEODt7PhzS4Tc=
Subject: [PATCH v13 12/12] famfs: Add documentation
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Mon, 10 Aug 2026 20:26:09 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
References: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com> 
 <20260810202559.96415-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAAFwXs
Thread-Topic: [PATCH v13 12/12] famfs: Add documentation
X-Wm-Sent-Timestamp: 1786393567
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5aa95d-21a4a553-a4af-476a-9903-43dd5af8a017-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.80

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd Documentation/filesyst=
ems/famfs.rst and update MAINTAINERS=0D=0A=0D=0AReviewed-by: Randy Dunlap=
 <rdunlap@infradead.org>=0D=0ATested-by: Randy Dunlap <rdunlap@infradead.=
org>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A Documentation=
/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++=0D=0A Documenta=
tion/filesystems/index.rst |   1 +=0D=0A MAINTAINERS                     =
    |   1 +=0D=0A 3 files changed, 144 insertions(+)=0D=0A create mode 10=
0644 Documentation/filesystems/famfs.rst=0D=0A=0D=0Adiff --git a/Document=
ation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst=0D=0Ane=
w file mode 100644=0D=0Aindex 000000000000..048791bcbcfd=0D=0A--- /dev/nu=
ll=0D=0A+++ b/Documentation/filesystems/famfs.rst=0D=0A@@ -0,0 +1,142 @@=0D=
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
s share read-only access=0D=0A+  to a file=0D=0A+=0D=0A+The famfs file sy=
stem is part of the famfs framework; user space=0D=0A+components [1] hand=
le metadata allocation and distribution, and populate=0D=0A+the in-kernel=
 files (via ioctls) so that they map directly to shared=0D=0A+memory.=0D=0A=
+=0D=0A+The famfs framework manages coherency of its own metadata and str=
uctures,=0D=0A+but does not attempt to manage coherency for applications.=
=0D=0A+=0D=0A+Famfs also provides data isolation between files. That is, =
even though=0D=0A+the host has access to an entire memory "device" (as a =
devdax device), apps=0D=0A+cannot write to memory for which the file is r=
ead-only, and mapping one=0D=0A+file provides isolation from the memory o=
f all other files. This is pretty=0D=0A+basic, but some experimental shar=
ed memory usage patterns provide no such=0D=0A+isolation.=0D=0A+=0D=0A+Pr=
inciples of Operation=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Famfs is a file system with one or =
more devdax devices as a first-class=0D=0A+backing device(s). Metadata ma=
intenance and query operations happen=0D=0A+entirely in user space.=0D=0A=
+=0D=0A+The famfs user space provides each file's map (fmap) and its back=
ing=0D=0A+devdax devices to the kernel through ioctls (FAMFSIOC_MAP_CREAT=
E and=0D=0A+FAMFSIOC_DAXDEV_OPEN), after which read/write/mapping faults =
are handled=0D=0A+entirely in the kernel with no up-calls for all active =
files.=0D=0A+=0D=0A+The famfs user space is responsible for maintaining a=
nd distributing=0D=0A+consistent metadata. This is currently handled via =
an append-only=0D=0A+metadata log within the memory, but this is orthogon=
al to the famfs=0D=0A+kernel code.=0D=0A+=0D=0A+Once instantiated, "the s=
ame file" on each host points to the same shared=0D=0A+memory, but in-mem=
ory metadata (inodes, etc.) is ephemeral on each host=0D=0A+that has a fa=
mfs instance mounted. Use cases are free to allow or not=0D=0A+allow muta=
tions to data on a file-by-file basis.=0D=0A+=0D=0A+When an app accesses =
a data object in a famfs file, there is no page cache=0D=0A+involvement. =
The CPU cache is loaded directly from the shared memory. In=0D=0A+some us=
e cases, this is an enormous reduction in read amplification=0D=0A+compar=
ed to loading an entire page into the page cache.=0D=0A+=0D=0A+=0D=0A+Fam=
fs is Not a Conventional File System=0D=0A+------------------------------=
---------=0D=0A+=0D=0A+Famfs files can be accessed by conventional means,=
 but there are=0D=0A+limitations. The famfs kernel module is not involved=
 in the allocation of=0D=0A+backing memory for files at all; the famfs us=
er space creates files and=0D=0A+supplies their fmaps and devdax device i=
nfo to the kernel via ioctls.=0D=0A+=0D=0A+Famfs differs in some importan=
t ways from conventional file systems:=0D=0A+=0D=0A+* Files must be pre-a=
llocated by the famfs framework; allocation is never=0D=0A+  performed on=
 (or after) write.=0D=0A+* Any operation that changes a file's size is co=
nsidered to put the file=0D=0A+  in an invalid state, disabling access to=
 the data. It may be possible to=0D=0A+  revisit this in the future. (Typ=
ically the famfs user space can restore=0D=0A+  files to a valid state by=
 replaying the famfs metadata log.)=0D=0A+=0D=0A+Famfs exists to apply th=
e existing file system abstractions to shared=0D=0A+memory so application=
s and workflows can more easily adapt to an=0D=0A+environment with disagg=
regated shared memory.=0D=0A+=0D=0A+Memory Error Handling=0D=0A+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Possi=
ble memory errors include timeouts, poison, and unexpected=0D=0A+reconfig=
uration of an underlying dax device. In all of these cases, famfs=0D=0A+r=
eceives a call from the devdax layer via its=0D=0A+dax_holder_operations-=
>notify_failure() function. If any memory errors have=0D=0A+been detected=
, access to the affected=0D=0A+daxdev is disabled to avoid further errors=
 or corruption.=0D=0A+=0D=0A+In all known cases, famfs can be unmounted c=
leanly. In most cases errors=0D=0A+can be cleared by re-initializing the =
memory - at which point a new famfs=0D=0A+file system can be created.=0D=0A=
+=0D=0A+Key Requirements=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=0D=0A+=0D=0A+The primary requirements for famfs are:=0D=0A+=0D=0A+=
1. Must support a file system abstraction backed by sharable devdax memor=
y=0D=0A+2. Files must efficiently handle VMA faults=0D=0A+3. Must support=
 metadata distribution in a sharable way=0D=0A+4. Must handle clients wit=
h a stale copy of metadata=0D=0A+=0D=0A+The famfs kernel component takes =
care of 1-2 above by caching each file's=0D=0A+mapping metadata in the ke=
rnel.=0D=0A+=0D=0A+Requirements 3 and 4 are handled by the user space com=
ponents, and are=0D=0A+largely orthogonal to the functionality of the fam=
fs kernel module.=0D=0A+=0D=0A+Requirements 3 and 4 cannot be met by conv=
entional fs-dax file systems=0D=0A+(e.g. xfs) because they use write-back=
 metadata; it is not valid to mount=0D=0A+such a file system on two hosts=
 from the same in-memory image.=0D=0A+=0D=0A+=0D=0A+Famfs Usage=0D=0A+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=0A+=0D=0A+Famfs usage is documented at =
[1].=0D=0A+=0D=0A+=0D=0A+References=0D=0A+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D=
=0A+=0D=0A+- [1] Famfs user space repository and documentation=0D=0A+    =
  https://github.com/cxl-micron-reskit/famfs=0D=0Adiff --git a/Documentat=
ion/filesystems/index.rst b/Documentation/filesystems/index.rst=0D=0Ainde=
x 1f71cf159547..97a9a1f1e96a 100644=0D=0A--- a/Documentation/filesystems/=
index.rst=0D=0A+++ b/Documentation/filesystems/index.rst=0D=0A@@ -91,6 +9=
1,7 @@ Documentation for filesystem implementations.=0D=0A    ext3=0D=0A =
   ext4/index=0D=0A    f2fs=0D=0A+   famfs=0D=0A    gfs2/index=0D=0A    h=
fs=0D=0A    hfsplus=0D=0Adiff --git a/MAINTAINERS b/MAINTAINERS=0D=0Ainde=
x 156fa62f7086..605b8d06f7d8 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b/MAI=
NTAINERS=0D=0A@@ -9910,6 +9910,7 @@ M:=09John Groves <john@groves.net>=0D=
=0A L:=09linux-fsdevel@vger.kernel.org=0D=0A L:=09linux-cxl@vger.kernel.o=
rg=0D=0A S:=09Supported=0D=0A+F:=09Documentation/filesystems/famfs.rst=0D=
=0A F:=09fs/famfs/=0D=0A=20=0D=0A FANOTIFY=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A
