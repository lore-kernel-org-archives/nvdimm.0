Received: from a11-129.smtp-out.amazonses.com (a11-129.smtp-out.amazonses.com [54.240.11.129])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1D39B495;
	Mon, 20 Jul 2026 03:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519154; cv=none; b=nJuisCLv+EG6LBLV17tbFxi7QCjnyK1y8mcoTr/gbgRczLlI55ETL7Wvf55RZtivMCOMMlWHLNUf9tb1nTpmKP/9XtRGJcYUTVdgAtBXt25yaZwNYp2O2zkdR7yyGf0pQdASQnYpCrjQicXNxNliucxxYs6GZlCEy3MbkxHTAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519154; c=relaxed/simple;
	bh=hVGKVtHtgR2yCFrnYopm1Od5hURg23Kx9xckNX1djJY=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=ix2H6DSvKNTMSu2F1WX+S24PZ+T6Lbeo5F8E3K7EnFoWDUtHJg/JZIub9uaeN0LfL3fREOFQ17h8rDa2tcmQvkKxtFRJ6IbaHoxuQY5Rr5UfEC83NUVT7jKTa1F44Qwi/2gF+2iD47mH8+fTe2fMLSm0/De3gNqDL21INnfRLOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=HPydlYCj; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ekpXT26n; arc=none smtp.client-ip=54.240.11.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="HPydlYCj";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ekpXT26n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519151;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=hVGKVtHtgR2yCFrnYopm1Od5hURg23Kx9xckNX1djJY=;
	b=HPydlYCjOy6TLeC5hdn59HP6b7QRI0LTxBTWB0fnLMB2O7kRWWJ5TRbm4eq8dh2F
	ii2UfxtBIbtjeztL9zzgwVPYwW2yW2Ebx1kGvJ8PWEoQnx7vXiYl/TkGy2o0A6I30pg
	slos/iGQ8dZ/hx7fFS+0UWKdcIL+5jOeJeELbRj4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519151;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=hVGKVtHtgR2yCFrnYopm1Od5hURg23Kx9xckNX1djJY=;
	b=ekpXT26ntMlQT/UGFcaecVNgT17c8C3a/pCtA53XOBO9zu/6vvAbKEmprpTENnUz
	DATfG/4Bvo32WGEUAnsENSOZvM30LL3IO8zAWL4z4vS9I7VCezD4KGFKAYUfJh+roz1
	eyFNYHc1jjlktieGoJLj8aAw588Bo54G8BkhhY4w=
Subject: [PATCH V11 3/9] famfs_fuse: Plumb the GET_FMAP message/response
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
Date: Mon, 20 Jul 2026 03:45:50 +0000
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
 <20260720034541.68781-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAADzdr
Thread-Topic: [PATCH V11 3/9] famfs_fuse: Plumb the GET_FMAP message/response
X-Wm-Sent-Timestamp: 1784519149
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da14ceb-fbd4edd7-ce17-4770-8c58-1296ad3e3fbe-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.129

From: John Groves <john@groves.net>=0D=0A=0D=0AOn completion of an OPEN i=
n famfs mode, issue a GET_FMAP request to the=0D=0Aserver to retrieve the=
 file's file-offset-to-dax map (fmap) and cache it=0D=0Aon the fuse_inode=
 (fi->famfs_meta). Once the map is cached, read, write=0D=0Aand mmap are =
resolved directly to dax with no further upcalls.=0D=0A=0D=0A- uapi: add =
the FUSE_GET_FMAP opcode.=0D=0A- famfs.c: add fuse_get_fmap(), which retr=
ieves the fmap into a=0D=0A  kvmalloc'd buffer. The fmap size is not know=
n in advance, so it uses a=0D=0A  size probe: it starts with a PAGE_SIZE =
buffer and passes that size to=0D=0A  the server (via fuse_getxattr_in.si=
ze). If the whole fmap does not=0D=0A  fit, the server replies with just =
the header, whose fmap_size field=0D=0A  reports the required size, and t=
he kernel reallocates exactly that and=0D=0A  retries once. The reply is =
bounded by FMAP_BUFSIZE_MAX (16 MiB); a=0D=0A  larger fmap is rejected wi=
th -EFBIG. A famfs file is fixed-size, so a=0D=0A  reply that reports a d=
ifferent size on the retry is rejected as a=0D=0A  server bug.=0D=0A- fil=
e.c: hook the OPEN path to fetch the fmap for regular files on a=0D=0A  f=
amfs connection; failure is fatal to the open.=0D=0A- fuse_i.h/inode.c: a=
dd the fi->famfs_meta pointer and its init/free=0D=0A  helpers.=0D=0A=0D=0A=
The retrieved map is parsed into its in-memory form in the following=0D=0A=
patch.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=
=0A MAINTAINERS               |   7 ++=0D=0A fs/fuse/Makefile          | =
  1 +=0D=0A fs/fuse/famfs.c           | 134 +++++++++++++++++++++++++++++=
+++++++++=0D=0A fs/fuse/file.c            |  14 +++-=0D=0A fs/fuse/fuse_i=
=2Eh          |  70 ++++++++++++++++++--=0D=0A fs/fuse/inode.c           =
|   8 ++-=0D=0A fs/fuse/iomode.c          |   2 +-=0D=0A include/uapi/lin=
ux/fuse.h |   3 +=0D=0A 8 files changed, 231 insertions(+), 8 deletions(-=
)=0D=0A create mode 100644 fs/fuse/famfs.c=0D=0A=0D=0Adiff --git a/MAINTA=
INERS b/MAINTAINERS=0D=0Aindex 806bd2d80d15..0d0fded4fddb 100644=0D=0A---=
 a/MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -10713,6 +10713,13 @@ F:=09=
fs/fuse/backing.c=0D=0A F:=09fs/fuse/iomode.c=0D=0A F:=09fs/fuse/passthro=
ugh.c=0D=0A=20=0D=0A+FUSE FILESYSTEM [FAMFS Fabric-Attached Memory File S=
ystem]=0D=0A+M:=09John Groves <John@Groves.net>=0D=0A+L:=09linux-cxl@vger=
=2Ekernel.org=0D=0A+L:=09linux-fsdevel@vger.kernel.org=0D=0A+S:=09Support=
ed=0D=0A+F:=09fs/fuse/famfs.c=0D=0A+=0D=0A FUTEX SUBSYSTEM=0D=0A M:=09Tho=
mas Gleixner <tglx@kernel.org>=0D=0A M:=09Ingo Molnar <mingo@redhat.com>=0D=
=0Adiff --git a/fs/fuse/Makefile b/fs/fuse/Makefile=0D=0Aindex 245e67852b=
03..66507b9cfe1f 100644=0D=0A--- a/fs/fuse/Makefile=0D=0A+++ b/fs/fuse/Ma=
kefile=0D=0A@@ -18,5 +18,6 @@ fuse-$(CONFIG_FUSE_DAX) +=3D dax.o=0D=0A fu=
se-$(CONFIG_FUSE_PASSTHROUGH) +=3D passthrough.o backing.o=0D=0A fuse-$(C=
ONFIG_SYSCTL) +=3D sysctl.o=0D=0A fuse-$(CONFIG_FUSE_IO_URING) +=3D dev_u=
ring.o=0D=0A+fuse-$(CONFIG_FUSE_FAMFS_DAX) +=3D famfs.o=0D=0A=20=0D=0A vi=
rtiofs-y :=3D virtio_fs.o=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/fam=
fs.c=0D=0Anew file mode 100644=0D=0Aindex 000000000000..80e6640ac970=0D=0A=
--- /dev/null=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -0,0 +1,134 @@=0D=0A+// =
SPDX-License-Identifier: GPL-2.0=0D=0A+/*=0D=0A+ * famfs - dax file syste=
m for shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2026=
 Micron Technology, Inc.=0D=0A+ *=0D=0A+ * This file system, originally b=
ased on ramfs the dax support from xfs,=0D=0A+ * is intended to allow mul=
tiple host systems to mount a common file system=0D=0A+ * view of dax fil=
es that map to shared memory.=0D=0A+ */=0D=0A+=0D=0A+#include <linux/clea=
nup.h>=0D=0A+#include <linux/fs.h>=0D=0A+#include <linux/mm.h>=0D=0A+#inc=
lude <linux/dax.h>=0D=0A+#include <linux/iomap.h>=0D=0A+#include <linux/p=
ath.h>=0D=0A+#include <linux/namei.h>=0D=0A+#include <linux/string.h>=0D=0A=
+=0D=0A+#include "fuse_i.h"=0D=0A+=0D=0A+=0D=0A+#define FMAP_BUFSIZE_INIT=
 PAGE_SIZE=0D=0A+/*=0D=0A+ * Largest GET_FMAP reply buffer we will kvmall=
oc. Any fmap whose whole message=0D=0A+ * fits in this buffer is handled;=
 there is no separate extent-count cap, so the=0D=0A+ * effective extent =
limit is just this size / sizeof(simple_ext) (~699k extents=0D=0A+ * =3D>=
 ~1.3 TiB per striped file at a 2 MiB chunk). kvmalloc-backed, so it may=0D=
=0A+ * exceed the contiguous kmalloc limit. Matches the server's reply-bu=
ffer cap.=0D=0A+ */=0D=0A+#define FMAP_BUFSIZE_MAX (16 * 1024 * 1024)=0D=0A=
+=0D=0A+int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)=0D=0A=
+{=0D=0A+=09struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A+=09u64=
 nodeid =3D get_node_id(inode);=0D=0A+=09size_t bufsize =3D FMAP_BUFSIZE_=
INIT;=0D=0A+=09void *fmap_buf =3D NULL;=0D=0A+=09ssize_t fmap_size;=0D=0A=
+=09int attempt;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09/* Don't retrieve if we=
 already have the famfs metadata */=0D=0A+=09if (fi->famfs_meta)=0D=0A+=09=
=09return 0;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * The fmap size is not known in=
 advance. Start with a modest buffer and,=0D=0A+=09 * if the server repor=
ts (via the returned header's fmap_size) that the=0D=0A+=09 * whole fmap =
did not fit, reallocate exactly that size and retry once.=0D=0A+=09 * The=
 server learns our buffer size from the request's=0D=0A+=09 * fuse_getxat=
tr_in.size (GETXATTR-style size probe).=0D=0A+=09 */=0D=0A+=09for (attemp=
t =3D 0; ; attempt++) {=0D=0A+=09=09struct fuse_getxattr_in in =3D { .siz=
e =3D bufsize };=0D=0A+=09=09struct fuse_famfs_fmap_header *fmh;=0D=0A+=09=
=09u32 required;=0D=0A+=0D=0A+=09=09FUSE_ARGS(args);=0D=0A+=0D=0A+=09=09f=
map_buf =3D kvmalloc(bufsize, GFP_KERNEL);=0D=0A+=09=09if (!fmap_buf)=0D=0A=
+=09=09=09return -ENOMEM;=0D=0A+=0D=0A+=09=09args.opcode =3D FUSE_GET_FMA=
P;=0D=0A+=09=09args.nodeid =3D nodeid;=0D=0A+=09=09args.in_numargs =3D 1;=
=0D=0A+=09=09args.in_args[0].size =3D sizeof(in);=0D=0A+=09=09args.in_arg=
s[0].value =3D &in;=0D=0A+=09=09/*=0D=0A+=09=09 * Variable-sized output b=
uffer; fuse_simple_request() returns=0D=0A+=09=09 * the size of the outpu=
t payload.=0D=0A+=09=09 */=0D=0A+=09=09args.out_argvar =3D true;=0D=0A+=09=
=09args.out_numargs =3D 1;=0D=0A+=09=09args.out_args[0].size =3D bufsize;=
=0D=0A+=09=09args.out_args[0].value =3D fmap_buf;=0D=0A+=0D=0A+=09=09rc =3D=
 fuse_simple_request(fm, &args);=0D=0A+=09=09if (rc < 0) {=0D=0A+=09=09=09=
pr_err("%s: err=3D%d from fuse_simple_request()\n",=0D=0A+=09=09=09      =
 __func__, rc);=0D=0A+=09=09=09kvfree(fmap_buf);=0D=0A+=09=09=09return rc=
;=0D=0A+=09=09}=0D=0A+=09=09fmap_size =3D rc;=0D=0A+=0D=0A+=09=09/* Need =
at least a header to learn the required size */=0D=0A+=09=09if (fmap_size=
 < (ssize_t)sizeof(*fmh)) {=0D=0A+=09=09=09pr_err("%s: short fmap reply %=
zd\n", __func__, fmap_size);=0D=0A+=09=09=09kvfree(fmap_buf);=0D=0A+=09=09=
=09return -EIO;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09fmh =3D fmap_buf;=0D=0A+=
=09=09required =3D fmh->fmap_size;=0D=0A+=0D=0A+=09=09/* Whole fmap fit i=
n the buffer -> parse it */=0D=0A+=09=09if (required <=3D bufsize)=0D=0A+=
=09=09=09break;=0D=0A+=0D=0A+=09=09/* Too small: server sent only the hea=
der. Grow and retry once. */=0D=0A+=09=09kvfree(fmap_buf);=0D=0A+=09=09fm=
ap_buf =3D NULL;=0D=0A+=0D=0A+=09=09if (required > FMAP_BUFSIZE_MAX) {=0D=
=0A+=09=09=09pr_err("%s: fmap size %u exceeds max %zu\n",=0D=0A+=09=09=09=
       __func__, required, (size_t)FMAP_BUFSIZE_MAX);=0D=0A+=09=09=09retu=
rn -EFBIG;=0D=0A+=09=09}=0D=0A+=09=09if (attempt >=3D 1) {=0D=0A+=09=09=09=
/*=0D=0A+=09=09=09 * A famfs file is fixed-size, so the server must repor=
t=0D=0A+=09=09=09 * the same fmap_size on the retry as on the first=0D=0A=
+=09=09=09 * request. A larger value means the file's size/fmap=0D=0A+=09=
=09=09 * changed between the two GET_FMAPs -- a server bug.=0D=0A+=09=09=09=
 */=0D=0A+=09=09=09pr_err("%s: fmap grew %zu -> %u across GET_FMAP retrie=
s; famfs file size must not change (server bug)\n",=0D=0A+=09=09=09      =
 __func__, bufsize, required);=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09=
}=0D=0A+=09=09bufsize =3D required;=0D=0A+=09}=0D=0A+=0D=0A+=09/* We retr=
ieved the "fmap" (the file's map to memory), but=0D=0A+=09 * we haven't u=
sed it yet. A call to famfs_file_init_dax() will be added=0D=0A+=09 * her=
e in a subsequent patch, when we add the ability to attach=0D=0A+=09 * fm=
aps to files.=0D=0A+=09 */=0D=0A+=0D=0A+=09kvfree(fmap_buf);=0D=0A+=09ret=
urn 0;=0D=0A+}=0D=0Adiff --git a/fs/fuse/file.c b/fs/fuse/file.c=0D=0Aind=
ex 995e37c935c6..b4e7b6a64587 100644=0D=0A--- a/fs/fuse/file.c=0D=0A+++ b=
/fs/fuse/file.c=0D=0A@@ -282,6 +282,16 @@ static int fuse_open(struct ino=
de *inode, struct file *file)=0D=0A =09err =3D fuse_do_open(fm, get_node_=
id(inode), file, false);=0D=0A =09if (!err) {=0D=0A =09=09ff =3D file->pr=
ivate_data;=0D=0A+=0D=0A+=09=09if ((fm->fc->famfs_iomap) && (S_ISREG(inod=
e->i_mode))) {=0D=0A+=09=09=09/* Get the famfs fmap - failure is fatal */=
=0D=0A+=09=09=09err =3D fuse_get_fmap(fm, inode);=0D=0A+=09=09=09if (err)=
 {=0D=0A+=09=09=09=09fuse_sync_release(fi, ff, file->f_flags);=0D=0A+=09=09=
=09=09goto out_nowrite;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A =09=09=
err =3D fuse_finish_open(inode, file);=0D=0A =09=09if (err)=0D=0A =09=09=09=
fuse_sync_release(fi, ff, file->f_flags);=0D=0A@@ -289,12 +299,14 @@ stat=
ic int fuse_open(struct inode *inode, struct file *file)=0D=0A =09=09=09f=
use_truncate_update_attr(inode, file);=0D=0A =09}=0D=0A=20=0D=0A+out_nowr=
ite:=0D=0A =09if (is_wb_truncate || dax_truncate)=0D=0A =09=09fuse_releas=
e_nowrite(inode);=0D=0A =09if (!err) {=0D=0A =09=09if (is_truncate)=0D=0A=
 =09=09=09truncate_pagecache(inode, 0);=0D=0A-=09=09else if (!(ff->open_f=
lags & FOPEN_KEEP_CACHE))=0D=0A+=09=09else if (!(ff->open_flags & FOPEN_K=
EEP_CACHE) &&=0D=0A+=09=09=09 !fuse_file_famfs(fi))=0D=0A =09=09=09invali=
date_inode_pages2(inode->i_mapping);=0D=0A =09}=0D=0A =09if (dax_truncate=
)=0D=0Adiff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 9c3541=
18c931..5bacc5098620 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fus=
e/fuse_i.h=0D=0A@@ -236,6 +236,14 @@ struct fuse_inode {=0D=0A =09 * be m=
odified, so preserve the blocksize specified by the server.=0D=0A =09 */=0D=
=0A =09u8 cached_i_blkbits;=0D=0A+=0D=0A+#if IS_ENABLED(CONFIG_FUSE_FAMFS=
_DAX)=0D=0A+=09/* Pointer to the file's famfs metadata. Primary content i=
s the=0D=0A+=09 * in-memory version of the fmap - the map from file's off=
set range=0D=0A+=09 * to DAX memory=0D=0A+=09 */=0D=0A+=09void *famfs_met=
a;=0D=0A+#endif=0D=0A };=0D=0A=20=0D=0A /** FUSE inode state bits */=0D=0A=
@@ -1218,11 +1226,8 @@ void fuse_free_conn(struct fuse_conn *fc);=0D=0A=20=
=0D=0A /* dax.c */=0D=0A=20=0D=0A-static inline bool fuse_file_famfs(stru=
ct fuse_inode *fuse_inode) /* Will be superseded */=0D=0A-{=0D=0A-=09(voi=
d)fuse_inode;=0D=0A-=09return false;=0D=0A-}=0D=0A+static inline int fuse=
_file_famfs(struct fuse_inode *fi); /* forward */=0D=0A+=0D=0A #define FU=
SE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)=09\=0D=0A =09=09=
=09=09=09&& IS_DAX(&(fuse_inode)->inode)  \=0D=0A =09=09=09=09=09&& !fuse=
_file_famfs(fuse_inode))=0D=0A@@ -1339,4 +1344,59 @@ extern void fuse_sys=
ctl_unregister(void);=0D=0A #define fuse_sysctl_unregister()=09do { } whi=
le (0)=0D=0A #endif /* CONFIG_SYSCTL */=0D=0A=20=0D=0A+/* famfs.c */=0D=0A=
+=0D=0A+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=0A+void __famfs_meta_fre=
e(void *map);=0D=0A+=0D=0A+/* Set fi->famfs_meta =3D NULL regardless of p=
rior value */=0D=0A+static inline void famfs_meta_init(struct fuse_inode =
*fi)=0D=0A+{=0D=0A+=09fi->famfs_meta =3D NULL;=0D=0A+}=0D=0A+=0D=0A+/* Se=
t fi->famfs_meta iff the current value is NULL */=0D=0A+static inline str=
uct fuse_backing *famfs_meta_set(struct fuse_inode *fi,=0D=0A+=09=09=09=09=
=09=09  void *meta)=0D=0A+{=0D=0A+=09return cmpxchg(&fi->famfs_meta, NULL=
, meta);=0D=0A+}=0D=0A+=0D=0A+static inline void famfs_meta_free(struct f=
use_inode *fi)=0D=0A+{=0D=0A+=09famfs_meta_set(fi, NULL);=0D=0A+}=0D=0A+=0D=
=0A+static inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0A+{=0D=0A=
+=09return (READ_ONCE(fi->famfs_meta) !=3D NULL);=0D=0A+}=0D=0A+=0D=0A+in=
t fuse_get_fmap(struct fuse_mount *fm, struct inode *inode);=0D=0A+=0D=0A=
+#else /* !CONFIG_FUSE_FAMFS_DAX */=0D=0A+=0D=0A+static inline struct fus=
e_backing *famfs_meta_set(struct fuse_inode *fi,=0D=0A+=09=09=09=09=09=09=
  void *meta)=0D=0A+{=0D=0A+=09return NULL;=0D=0A+}=0D=0A+=0D=0A+static i=
nline void famfs_meta_free(struct fuse_inode *fi)=0D=0A+{=0D=0A+}=0D=0A+=0D=
=0A+static inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0A+{=0D=0A=
+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static inline int=0D=0A+fuse_get_fmap(=
struct fuse_mount *fm, struct inode *inode)=0D=0A+{=0D=0A+=09return 0;=0D=
=0A+}=0D=0A+=0D=0A+#endif /* CONFIG_FUSE_FAMFS_DAX */=0D=0A+=0D=0A #endif=
 /* _FS_FUSE_I_H */=0D=0Adiff --git a/fs/fuse/inode.c b/fs/fuse/inode.c=0D=
=0Aindex c347471d04b6..e030a302120f 100644=0D=0A--- a/fs/fuse/inode.c=0D=0A=
+++ b/fs/fuse/inode.c=0D=0A@@ -106,6 +106,9 @@ static struct inode *fuse_=
alloc_inode(struct super_block *sb)=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_P=
ASSTHROUGH))=0D=0A =09=09fuse_inode_backing_set(fi, NULL);=0D=0A=20=0D=0A=
+=09if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09=09famfs_meta_set(fi,=
 NULL);=0D=0A+=0D=0A =09return &fi->inode;=0D=0A=20=0D=0A out_free_forget=
:=0D=0A@@ -127,6 +130,9 @@ static void fuse_free_inode(struct inode *inod=
e)=0D=0A =09if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09fuse_bac=
king_put(fuse_inode_backing(fi));=0D=0A=20=0D=0A+=09if (S_ISREG(inode->i_=
mode) && fuse_file_famfs(fi))=0D=0A+=09=09famfs_meta_free(fi);=0D=0A+=0D=0A=
 =09kmem_cache_free(fuse_inode_cachep, fi);=0D=0A }=0D=0A=20=0D=0A@@ -148=
,7 +154,7 @@ static void fuse_evict_inode(struct inode *inode)=0D=0A =09/=
* Will write inode on close/munmap and in all other dirtiers */=0D=0A =09=
WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);=0D=0A=20=0D=0A-=09=
if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi) || fuse_f=
ile_famfs(fi))=0D=0A =09=09dax_break_layout_final(inode);=0D=0A=20=0D=0A =
=09truncate_inode_pages_final(&inode->i_data);=0D=0Adiff --git a/fs/fuse/=
iomode.c b/fs/fuse/iomode.c=0D=0Aindex 31ee7f3304c6..948148316ef0 100644=0D=
=0A--- a/fs/fuse/iomode.c=0D=0A+++ b/fs/fuse/iomode.c=0D=0A@@ -203,7 +203=
,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)=0D=0A=
 =09 * io modes are not relevant with DAX and with server that does not=0D=
=0A =09 * implement open.=0D=0A =09 */=0D=0A-=09if (FUSE_IS_VIRTIO_DAX(fi=
) || !ff->args)=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi=
) || !ff->args)=0D=0A =09=09return 0;=0D=0A=20=0D=0A =09/*=0D=0Adiff --gi=
t a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h=0D=0Aindex 2568=
6f088e6a..d323c20e79bd 100644=0D=0A--- a/include/uapi/linux/fuse.h=0D=0A+=
++ b/include/uapi/linux/fuse.h=0D=0A@@ -669,6 +669,9 @@ enum fuse_opcode =
{=0D=0A =09FUSE_STATX=09=09=3D 52,=0D=0A =09FUSE_COPY_FILE_RANGE_64=09=3D=
 53,=0D=0A=20=0D=0A+=09/* Famfs / devdax opcodes */=0D=0A+=09FUSE_GET_FMA=
P           =3D 54,=0D=0A+=0D=0A =09/* CUSE specific operations */=0D=0A =
=09CUSE_INIT=09=09=3D 4096,=0D=0A=20=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
