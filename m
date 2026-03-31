Received: from a8-40.smtp-out.amazonses.com (a8-40.smtp-out.amazonses.com [54.240.8.40])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A0F3E1CE4
	for <nvdimm@lists.linux.dev>; Tue, 31 Mar 2026 12:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960782; cv=none; b=MAxFD4nUdApaojG1R0Yzc3Mf0lEeVwedWPFlkF/vgdom1Llu0dwWtVvJgshkse8xfuQRk0vay6KdZCIx7Fddv9sOXLybX4muT+5K0LwYGMzJUoKZnvbFqQTaJ07MzVmGU6IoqdivbjSvHtVMjfUqveUt+C+Xpg1EAncDDNmz+M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960782; c=relaxed/simple;
	bh=D+N7TwRkCMJVOnBlkgJcpZilU8uPVzgv+cd9JtA2Xlk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=LjVdjQ6SXJx4Ya4edUSPmClbVgP1sDggW1HTLrnK1bk/Cxwl+emz/ijdimCEO2mki1MSdPHPCSRO756YqZ78oHzbnjY/D/I6YAHjY63SgX63UJHJS7DR8ReOn279FGeuWnAxBtYy+mK1yAF22J3y06Qm7OSVndpQac14o+KSozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=K7Ew4MR5; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=aXpxYrw2; arc=none smtp.client-ip=54.240.8.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="K7Ew4MR5";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="aXpxYrw2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774960779;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=D+N7TwRkCMJVOnBlkgJcpZilU8uPVzgv+cd9JtA2Xlk=;
	b=K7Ew4MR5veQip5A/EtWXPurn8iPpSkosDMqzLhjBRLV9oAjTqwIrbCjNKXCKPweD
	XuFWKfL/KWombN9uRLyaAV2eUJ0LDej1DmPos/3Hc4WlSjpQejLkJJ5IxYPZn5zqGQr
	fRofInYTF6NIUshhTe0wI2FJBJwIl1AvOu/HeAHA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774960779;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=D+N7TwRkCMJVOnBlkgJcpZilU8uPVzgv+cd9JtA2Xlk=;
	b=aXpxYrw2+NaECg2pTZdxOs+OwT3oiAKB7NdcFOMqJcnHa6nyt04rOrMUhY5m4g+T
	4ZQ48Q7zsR5x3nQ9Nt8sY5siYe/MbUxuGgmw+qxEgIX3ivdKB3dOVmedyP9ZCsqzIM7
	Cj8djKy0JfA5vNBz6nYl7gADmKe5b3snyFn9g4I0=
Subject: [PATCH V10 09/10] famfs_fuse: Add famfs fmap metadata documentation
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
Date: Tue, 31 Mar 2026 12:39:39 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
References: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com> 
 <20260331123931.35242-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcwQsa9c5CQiOAQiO0uvZd0I9uvwAAFWE9
Thread-Topic: [PATCH V10 09/10] famfs_fuse: Add famfs fmap metadata
 documentation
X-Wm-Sent-Timestamp: 1774960778
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d43e82014-50e3d3fe-3f73-4807-9f74-a6633c245ea3-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.31-54.240.8.40

From: John Groves <John@Groves.net>=0D=0A=0D=0AThis describes the fmap me=
tadata - both simple and interleaved=0D=0A=0D=0AReviewed-by: Dave Jiang <=
dave.jiang@intel.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=
=0A---=0D=0A fs/fuse/famfs_kfmap.h | 73 +++++++++++++++++++++++++++++++++=
++++++++++=0D=0A 1 file changed, 73 insertions(+)=0D=0A=0D=0Adiff --git a=
/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h=0D=0Aindex 0fff841f5a9e..9=
70ad802b492 100644=0D=0A--- a/fs/fuse/famfs_kfmap.h=0D=0A+++ b/fs/fuse/fa=
mfs_kfmap.h=0D=0A@@ -7,6 +7,79 @@=0D=0A #ifndef FAMFS_KFMAP_H=0D=0A #defi=
ne FAMFS_KFMAP_H=0D=0A=20=0D=0A+/* KABI version 43 (aka v2) fmap structur=
es=0D=0A+ *=0D=0A+ * The location of the memory backing for a famfs file =
is described by=0D=0A+ * the response to the GET_FMAP fuse message (defin=
ed in=0D=0A+ * include/uapi/linux/fuse.h=0D=0A+ *=0D=0A+ * There are curr=
ently two extent formats: Simple and Interleaved.=0D=0A+ *=0D=0A+ * Simpl=
e extents are just (devindex, offset, length) tuples, where devindex=0D=0A=
+ * references a devdax device that must be retrievable via the GET_DAXDE=
V=0D=0A+ * message/response.=0D=0A+ *=0D=0A+ * The extent list size must =
be >=3D file_size.=0D=0A+ *=0D=0A+ * Interleaved extents merit some addit=
ional explanation. Interleaved=0D=0A+ * extents stripe data across a coll=
ection of strips. Each strip is a=0D=0A+ * contiguous allocation from a s=
ingle devdax device - and is described by=0D=0A+ * a simple_extent struct=
ure.=0D=0A+ *=0D=0A+ * Interleaved_extent example:=0D=0A+ *   ie_nstrips =
=3D 4=0D=0A+ *   ie_chunk_size =3D 2MiB=0D=0A+ *   ie_nbytes =3D 24MiB=0D=
=0A+ *=0D=0A+ * =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=0D=0A+ * =E2=94=82Chunk =3D=
 0   =E2=94=82Chunk =3D 1   =E2=94=82Chunk =3D 2   =E2=94=82Chunk =3D 3  =
 =E2=94=82=0D=0A+ * =E2=94=82Strip =3D 0   =E2=94=82Strip =3D 1   =E2=94=82=
Strip =3D 2   =E2=94=82Strip =3D 3   =E2=94=82=0D=0A+ * =E2=94=82Stripe =3D=
 0  =E2=94=82Stripe =3D 0  =E2=94=82Stripe =3D 0  =E2=94=82Stripe =3D 0  =
=E2=94=82=0D=0A+ * =E2=94=82            =E2=94=82            =E2=94=82   =
         =E2=94=82            =E2=94=82=0D=0A+ * =E2=94=94=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98=0D=0A+ * =E2=94=82Chunk =3D 4   =E2=94=82Chunk =3D 5   =E2=94=82Chunk=
 =3D 6   =E2=94=82Chunk =3D 7   =E2=94=82=0D=0A+ * =E2=94=82Strip =3D 0  =
 =E2=94=82Strip =3D 1   =E2=94=82Strip =3D 2   =E2=94=82Strip =3D 3   =E2=
=94=82=0D=0A+ * =E2=94=82Stripe =3D 1  =E2=94=82Stripe =3D 1  =E2=94=82St=
ripe =3D 1  =E2=94=82Stripe =3D 1  =E2=94=82=0D=0A+ * =E2=94=82          =
  =E2=94=82            =E2=94=82            =E2=94=82            =E2=94=82=
=0D=0A+ * =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=0D=0A+ * =E2=94=82Chunk =3D 8   =E2=
=94=82Chunk =3D 9   =E2=94=82Chunk =3D 10  =E2=94=82Chunk =3D 11  =E2=94=82=
=0D=0A+ * =E2=94=82Strip =3D 0   =E2=94=82Strip =3D 1   =E2=94=82Strip =3D=
 2   =E2=94=82Strip =3D 3   =E2=94=82=0D=0A+ * =E2=94=82Stripe =3D 2  =E2=
=94=82Stripe =3D 2  =E2=94=82Stripe =3D 2  =E2=94=82Stripe =3D 2  =E2=94=82=
=0D=0A+ * =E2=94=82            =E2=94=82            =E2=94=82            =
=E2=94=82            =E2=94=82=0D=0A+ * =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=0D=0A=
+ *=0D=0A+ * * Data is laid out across chunks in chunk # order=0D=0A+ * *=
 Columns are strips=0D=0A+ * * Strips are contiguous devdax extents, norm=
ally each coming from a=0D=0A+ *   different memory device=0D=0A+ * * Row=
s are stripes=0D=0A+ * * The number of chunks is (int)((file_size + chunk=
_size - 1) / chunk_size)=0D=0A+ *   (and obviously the last chunk could b=
e partial)=0D=0A+ * * The stripe_size =3D (nstrips * chunk_size)=0D=0A+ *=
 * chunk_num(offset) =3D offset / chunk_size    //integer division=0D=0A+=
 * * strip_num(offset) =3D chunk_num(offset) % nchunks=0D=0A+ * * stripe_=
num(offset) =3D offset / stripe_size  //integer division=0D=0A+ * * ...Yo=
u get the idea - see the code for more details...=0D=0A+ *=0D=0A+ * Some =
concrete examples from the layout above:=0D=0A+ * * Offset 0 in the file =
is offset 0 in chunk 0, which is offset 0 in=0D=0A+ *   strip 0=0D=0A+ * =
* Offset 4MiB in the file is offset 0 in chunk 2, which is offset 0 in=0D=
=0A+ *   strip 2=0D=0A+ * * Offset 15MiB in the file is offset 1MiB in ch=
unk 7, which is offset=0D=0A+ *   3MiB in strip 3=0D=0A+ *=0D=0A+ * Notes=
 about this metadata format:=0D=0A+ *=0D=0A+ * * For various reasons, chu=
nk_size must be a multiple of the applicable=0D=0A+ *   PAGE_SIZE=0D=0A+ =
* * Since chunk_size and nstrips are constant within an interleaved_exten=
t,=0D=0A+ *   resolving a file offset to a strip offset within a single=0D=
=0A+ *   interleaved_ext is order 1.=0D=0A+ * * If nstrips=3D=3D1, a list=
 of interleaved_ext structures degenerates to a=0D=0A+ *   regular extent=
 list (albeit with some wasted struct space).=0D=0A+ */=0D=0A+=0D=0A /*=0D=
=0A  * The structures below are the in-memory metadata format for famfs f=
iles.=0D=0A  * Metadata retrieved via the GET_FMAP response is converted =
to this format=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
