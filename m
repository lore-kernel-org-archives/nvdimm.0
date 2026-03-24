Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E10B3002D8
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312849; cv=none; b=adBbVhCo4qscLXtSiLiB4uNjoodwHB4mons3s5W97SvXDyycs5PGsJi9l/aUihwQckW5+21wE9YZl0/u97IM3zaKYzgOSsfU/bNGu8wcUh3EEsJ0HB5ZRCQouupWxVwTIvE/6Zf9HgPfS51EBKqmo49qUkox+LL49BJlyuD08OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312849; c=relaxed/simple;
	bh=t6MOERI7N3wnQ6t8NvSOPDc2VUx/iEmo4Ssi506XmU8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=iOZYWRiLUmIyr37awykzzSGjpyhwg4C9AtWbt4OhbnA+aN7iqCwqUk7o7ba1pFxraKdhJ/wwMV5ougFVA0gJgzju5dpMHlWPgFxUMT3oUChT2yosarwdcprKEUpOj5bDUxXcM2zEOUQw/ULctjsA2ysElCf11wA2TH8YvadaSws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=sncnQO1f; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=hySMc19p; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="sncnQO1f";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="hySMc19p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312847;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=t6MOERI7N3wnQ6t8NvSOPDc2VUx/iEmo4Ssi506XmU8=;
	b=sncnQO1fA/md6erGnM6bh+m44fyxZXMHDXcE2c15nNVXYBUVCb+1agWWt+SAgBlL
	7ih3uvfCbEvTu9kNbJh8w9wJ4xJ8xsaVdzvboniso/4v4iGptS/wY4vIhD72Mjj4pgb
	xLzoX8BT4Rjg65uWk4NcURUQIsvSUIfUiwR5NOAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312847;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=t6MOERI7N3wnQ6t8NvSOPDc2VUx/iEmo4Ssi506XmU8=;
	b=hySMc19pQQrNZljeabGpI+KmUF47wZUNWugugPw/tYAXh1Fo7m+FYmwMfwVdpu+b
	LhH04JdgVv4uELlvnSJbutikneq+8/ngSF8dl2xCRj5FfbUoHKSWRpAGD1KuPA4nL3p
	OUlUzhAUpIsGTu55Pl/6xfYqsVGSC1RXDjIpZGIM=
Subject: [PATCH V9 02/10] famfs_fuse: Basic fuse kernel ABI enablement for
 famfs
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
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
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 24 Mar 2026 00:40:47 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
References: 
 <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com> 
 <20260324004039.5188-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuybZ2Ihh4xo+QJya/X/ZmX16jg==
Thread-Topic: [PATCH V9 02/10] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
X-Wm-Sent-Timestamp: 1774312845
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d497745-e7ddbc57-741e-46dd-8f8a-f88ef5655887-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.8.208

From: John Groves <john@groves.net>=0D=0A=0D=0AThis patch starts the kern=
el ABI enablement of famfs in fuse.=0D=0A=0D=0A- Kconfig: Add FUSE_FAMFS_=
DAX config parameter, to control=0D=0A  compilation of famfs within fuse.=
=0D=0A- FUSE_DAX_FMAP flag in INIT request/reply=0D=0A- fuse_conn->famfs_=
iomap (enable famfs-mapped files) to denote a=0D=0A  famfs-enabled connec=
tion=0D=0A=0D=0AReviewed-by: Joanne Koong <joannelkoong@gmail.com>=0D=0AR=
eviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ASigned-off-by: John Gr=
oves <john@groves.net>=0D=0A---=0D=0A fs/fuse/Kconfig           | 13 ++++=
+++++++++=0D=0A fs/fuse/fuse_i.h          |  3 +++=0D=0A fs/fuse/inode.c =
          |  6 ++++++=0D=0A include/uapi/linux/fuse.h |  5 +++++=0D=0A 4 =
files changed, 27 insertions(+)=0D=0A=0D=0Adiff --git a/fs/fuse/Kconfig b=
/fs/fuse/Kconfig=0D=0Aindex 3a4ae632c94a..17fe1f490cbd 100644=0D=0A--- a/=
fs/fuse/Kconfig=0D=0A+++ b/fs/fuse/Kconfig=0D=0A@@ -76,3 +76,16 @@ config=
 FUSE_IO_URING=0D=0A=20=0D=0A =09  If you want to allow fuse server/clien=
t communication through io-uring,=0D=0A =09  answer Y=0D=0A+=0D=0A+config=
 FUSE_FAMFS_DAX=0D=0A+=09bool "FUSE support for fs-dax filesystems backed=
 by devdax"=0D=0A+=09depends on FUSE_FS=0D=0A+=09depends on DEV_DAX_FSDEV=
=0D=0A+=09default FUSE_FS=0D=0A+=09help=0D=0A+=09  This enables the fabri=
c-attached memory file system (famfs),=0D=0A+=09  which enables formattin=
g devdax memory as a file system. Famfs=0D=0A+=09  is primarily intended =
for scale-out shared access to=0D=0A+=09  disaggregated memory.=0D=0A+=0D=
=0A+=09  To enable famfs or other fuse/fs-dax file systems, answer Y=0D=0A=
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 45e108dec771.=
=2E2839efb219a9 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fus=
e_i.h=0D=0A@@ -921,6 +921,9 @@ struct fuse_conn {=0D=0A =09/* Is synchron=
ous FUSE_INIT allowed=3F */=0D=0A =09unsigned int sync_init:1;=0D=0A=20=0D=
=0A+=09/* dev_dax_iomap support for famfs */=0D=0A+=09unsigned int famfs_=
iomap:1;=0D=0A+=0D=0A =09/* Use io_uring for communication */=0D=0A =09un=
signed int io_uring;=0D=0A=20=0D=0Adiff --git a/fs/fuse/inode.c b/fs/fuse=
/inode.c=0D=0Aindex 1333b3ebb18a..fa77add7d9f8 100644=0D=0A--- a/fs/fuse/=
inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@ -1456,6 +1456,10 @@ static voi=
d process_init_reply(struct fuse_mount *fm, struct fuse_args *args,=0D=0A=
=20=0D=0A =09=09=09if (flags & FUSE_REQUEST_TIMEOUT)=0D=0A =09=09=09=09ti=
meout =3D arg->request_timeout;=0D=0A+=0D=0A+=09=09=09if (IS_ENABLED(CONF=
IG_FUSE_FAMFS_DAX) &&=0D=0A+=09=09=09    flags & FUSE_DAX_FMAP)=0D=0A+=09=
=09=09=09fc->famfs_iomap =3D 1;=0D=0A =09=09} else {=0D=0A =09=09=09ra_pa=
ges =3D fc->max_read / PAGE_SIZE;=0D=0A =09=09=09fc->no_lock =3D 1;=0D=0A=
@@ -1517,6 +1521,8 @@ static struct fuse_init_args *fuse_new_init(struct =
fuse_mount *fm)=0D=0A =09=09flags |=3D FUSE_SUBMOUNTS;=0D=0A =09if (IS_EN=
ABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09flags |=3D FUSE_PASSTHROUGH;=0D=
=0A+=09if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09=09flags |=3D FUSE=
_DAX_FMAP;=0D=0A=20=0D=0A =09/*=0D=0A =09 * This is just an information f=
lag for fuse server. No need to check=0D=0Adiff --git a/include/uapi/linu=
x/fuse.h b/include/uapi/linux/fuse.h=0D=0Aindex c13e1f9a2f12..25686f088e6=
a 100644=0D=0A--- a/include/uapi/linux/fuse.h=0D=0A+++ b/include/uapi/lin=
ux/fuse.h=0D=0A@@ -240,6 +240,9 @@=0D=0A  *  - add FUSE_COPY_FILE_RANGE_6=
4=0D=0A  *  - add struct fuse_copy_file_range_out=0D=0A  *  - add FUSE_NO=
TIFY_PRUNE=0D=0A+ *=0D=0A+ *  7.46=0D=0A+ *  - Add FUSE_DAX_FMAP capabili=
ty - ability to handle in-kernel fsdax maps=0D=0A  */=0D=0A=20=0D=0A #ifn=
def _LINUX_FUSE_H=0D=0A@@ -448,6 +451,7 @@ struct fuse_file_lock {=0D=0A =
 * FUSE_OVER_IO_URING: Indicate that client supports io-uring=0D=0A  * FU=
SE_REQUEST_TIMEOUT: kernel supports timing out requests.=0D=0A  *=09=09=09=
 init_out.request_timeout contains the timeout (in secs)=0D=0A+ * FUSE_DA=
X_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps=0D=0A  */=0D=0A #=
define FUSE_ASYNC_READ=09=09(1 << 0)=0D=0A #define FUSE_POSIX_LOCKS=09(1 =
<< 1)=0D=0A@@ -495,6 +499,7 @@ struct fuse_file_lock {=0D=0A #define FUSE=
_ALLOW_IDMAP=09(1ULL << 40)=0D=0A #define FUSE_OVER_IO_URING=09(1ULL << 4=
1)=0D=0A #define FUSE_REQUEST_TIMEOUT=09(1ULL << 42)=0D=0A+#define FUSE_D=
AX_FMAP=09=09(1ULL << 43)=0D=0A=20=0D=0A /**=0D=0A  * CUSE INIT request/r=
eply flags=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
