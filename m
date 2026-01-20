Received: from a10-27.smtp-out.amazonses.com (a10-27.smtp-out.amazonses.com [54.240.10.27])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DAA453494
	for <nvdimm@lists.linux.dev>; Tue, 20 Jan 2026 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921991; cv=none; b=YLq3/ynxrVX4GJQ6f9mMo0CqXbacSlobfyz0E9SRn6v0nsdXDDHeKjOqDVRnDCgWFAaehLZ+U9VDqWXK6C8s1LF4OOrGsttkpMNN9mkOH5SN7G1JPOIbvRbi4c467L2i5Qn85Sxwu9wSpVjwVBnJyUGP+dOgSWFY+ECtO31avDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921991; c=relaxed/simple;
	bh=Ft0thuoltVVZMnW6hindS3fkwhaqA1m8xooBA/OmizE=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=gj6/RMoMuwXIClyZGTcFkWjowZ8Lzy89Pauj+sYQdPy/bbbkIQyC3RFjjc5EkSP69bdBLur5QiN1wwtgGfuRRZ5MFkGc1zJx4Yutj0USjUDZmcYiRJavEcuklA+TbeuIizODaLdcgGb/WgoHVHI+AL801RDGiBiidN2xq3ykTkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=qfuc4mv9; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Pr7cKIFm; arc=none smtp.client-ip=54.240.10.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="qfuc4mv9";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Pr7cKIFm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1768921988;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Ft0thuoltVVZMnW6hindS3fkwhaqA1m8xooBA/OmizE=;
	b=qfuc4mv9Ri4JjFpZWoeGrjIgi9GFt84DZVs7ldEBYK9qwSCbV+G7how3cn8E1njD
	R8qOMG8zOSinHT+yG+IhbI0eHyzyNyv4Y6YnOE6f4s/kORFFPBXrGrtylI2T44fBS2E
	L38p2ZbHFw4Rc8p1mwUuaytbQqp9aXzh2KwMmp0Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1768921988;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Ft0thuoltVVZMnW6hindS3fkwhaqA1m8xooBA/OmizE=;
	b=Pr7cKIFmHrGUrIvIzVRhb1/sTlFCAzumbBpqlIC98a7h1kqzf7JJ5Z0FZ5uY98R0
	DjL8uS1K8eFijzGAVW+BRj+WGt39y6s4sJjYQRfur3D/gk7YlxFl9Pi8KLWqk/eqTta
	62lVHk6gdgy3hxUN6HdkWYjWjI4ooWS3YTyjS8WA=
Subject: Re: [PATCH BUNDLE v7] famfs: Fabric-Attached Memory File System
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?Alireza_Sanaee?= <alireza.sanaee@huawei.com>
Cc: =?UTF-8?Q?John_Groves?= <John@groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?John_Groves?= <jgroves@fastmail.com>, 
	=?UTF-8?Q?Jonathan_Corbet?= <corbet@lwn.net>, 
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
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>
Date: Tue, 20 Jan 2026 15:13:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260120091217.00007537.alireza.sanaee@huawei.com>
References: <20260118222911.92214-1-john@jagalactic.com> 
 <0100019bd33a16b4-6da11a99-d883-4cfc-b561-97973253bc4a-000000@email.amazonses.com> 
 <20260120091217.00007537.alireza.sanaee@huawei.com> 
 <aW-bOXOnwUVVorHu@groves.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHciMnhcFkpAz6WTSKstYDfyF/cJQBI+YTyAFVZlts=
Thread-Topic: [PATCH BUNDLE v7] famfs: Fabric-Attached Memory File System
X-Wm-Sent-Timestamp: 1768921986
Message-ID: <0100019bdbf77d8b-fc329dba-dc0d-4233-9b6a-b45e3e271727-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.01.20-54.240.10.27

On 26/01/20 09:12AM, Alireza Sanaee wrote:=0D=0A> On Sun, 18 Jan 2026 22:=
29:18 +0000=0D=0A> John Groves <john@jagalactic.com> wrote:=0D=0A>=20=0D=0A=
> Hi John,=0D=0A>=20=0D=0A> I wonder if these new patches sent recently h=
ave been reflected on the github repo readme files. It seems it is not, i=
s it=3F=0D=0A>=20=0D=0A=0D=0A[ ... ]=0D=0A=0D=0A> >=20=0D=0A> > Reference=
s=0D=0A> > ----------=0D=0A> > [1] https://lore.kernel.org/linux-cxl/cove=
r.1708709155.git.john@groves.net/=0D=0A> > [2] https://lore.kernel.org/li=
nux-cxl/cover.1714409084.git.john@groves.net/=0D=0A> > [3] https://lwn.ne=
t/Articles/983105/ (LSFMM 2024)=0D=0A> > [4] https://lwn.net/Articles/102=
0170/ (LSFMM 2025)=0D=0A> > [5] https://famfs.org (famfs user space)=0D=0A=
> > [6] https://lore.kernel.org/linux-cxl/20250703185032.46568-1-john@gro=
ves.net/ (V2)=0D=0A> > [7] https://lore.kernel.org/linux-fsdevel/20260107=
153244.64703-1-john@groves.net/T/#m0000d8c00290f48c086b8b176c7525e410f850=
8c (related ndctl series)=0D=0A> > --=0D=0A=0D=0AHi Ali,=0D=0A=0D=0A[5] p=
oints to the main famfs user space repo; I haven't updated documentation=0D=
=0Athere yet. The master branch there works with this patch set, and also=
=0D=0Aremains compatible with famfs kernels back to 6.8 (both fuse and st=
andalone),=0D=0Abut I recommend this latest version (which is the famfs-v=
7 tag in my kernel=0D=0Arepos).=0D=0A=0D=0ASome people are still running =
standalone famfs, and for that I recommend the=0D=0Afamfs_dualv3 branch, =
which supports both fuse and standalone mounts in a=0D=0A6.14 kernel. I d=
on't currently plan to forward-port standalone famfs to=0D=0A6.19, becaus=
e fuse is the path forward.=0D=0A=0D=0AWe're working on a performance reg=
ression test suite now, but early=0D=0Aindications are the fuse version i=
s equivalent performance to standalone -=0D=0Aexcept for open, which is s=
lower due to the fuse kernel/server interaction.=0D=0AMost of our use cas=
es involve large data sets, so we think this is OK - but=0D=0Athere is an=
 opportunity later optimization of open.=0D=0A=0D=0AHope this is helpful,=
=0D=0AJohn=0D=0A=0D=0A
