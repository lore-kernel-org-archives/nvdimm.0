Received: from a48-178.smtp-out.amazonses.com (a48-178.smtp-out.amazonses.com [54.240.48.178])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5968929BDBC
	for <nvdimm@lists.linux.dev>; Sun, 18 Jan 2026 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768775764; cv=none; b=JCyd1vjALpm0TpTFficfimm688o6UIZEmaWKmFRrLp4FAh4DuzuIZ0nGSBKRLsXC0KjfCk+JYuiGB9kWW2wOLmt7UMSYBGrr/cjP4nRfIaT9z7FXDOMAoeEITwgMcGCcAiYHjUlx9qazZM8qWxhRgcCTpfEUZNNY3VWFvSbwPkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768775764; c=relaxed/simple;
	bh=XmUW7Cmh9jiGTs6VsQXuxuYvkOlKxJGPYQ6IMGglU4U=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=YOVrcA0UXDTa/n5DdGQosHv+0lFEKo80hmfwiTnpi9KEvfmCFUa5G01JEMyLYlKCmlsFfyntlXmzCU7N57K0e8qokcWg7WmTOLFuJRdBTiqfCe++D5IVQf5vnWq6NunWwigBfheCjfOq9DGzDIiFlTFQsdr5ZWhwpBAmwSeU04w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ktksZlmg; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=kmQi0oHA; arc=none smtp.client-ip=54.240.48.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ktksZlmg";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="kmQi0oHA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1768775762;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=XmUW7Cmh9jiGTs6VsQXuxuYvkOlKxJGPYQ6IMGglU4U=;
	b=ktksZlmgK0ZbUVcCC0i0lO+swMi1JP8pX29czxFNQtZ9PEoKQuTr2NQ9QR0wIhUw
	493HMUE350MgzCnNo33EIunvN15pKos+O1E9dkNVTjUfplrEFIVluBemboWr67Mfdli
	wR8Wexid2zkCvEmL/pugPA5mFUwtRMI5XkE+oNt0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1768775762;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=XmUW7Cmh9jiGTs6VsQXuxuYvkOlKxJGPYQ6IMGglU4U=;
	b=kmQi0oHAfQDBFWJdcrwVQfmEBeL6zDzbqcp+QxTycXfVsDNXhxJt4j4390AWPaAI
	Rj8i9RVlaVJKrS3tJulZcMRrZmdXQ3IgZUV7AYqhTvJIpsczDXzeU+K/1M+zpCdw83a
	krtNoeNOFYPOiiQAqnyM4JQ8biTL1fG/8ocSdaE4=
Subject: [PATCH V4 0/2] ndctl: Add daxctl support for the new "famfs" mode of
 devdax
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
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
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sun, 18 Jan 2026 22:36:02 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019bd33a16b4-6da11a99-d883-4cfc-b561-97973253bc4a-000000@email.amazonses.com>
References: 
 <0100019bd33a16b4-6da11a99-d883-4cfc-b561-97973253bc4a-000000@email.amazonses.com> 
 <20260118223548.92823-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHciMnhcFkpAz6WTSKstYDfyF/cJQAAPD1q
Thread-Topic: [PATCH V4 0/2] ndctl: Add daxctl support for the new "famfs"
 mode of devdax
X-Wm-Sent-Timestamp: 1768775760
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.01.18-54.240.48.178

From: John Groves <john@groves.net>

No change since V2 - re-sending due to technical challenges.

No change since V1 - reposting as V2 to keep this with the related
kernel (dax and fuse) patches and libfuse patches.

This short series adds support and tests to daxctl for famfs[1]. The
famfs kernel patch series, under the same "compound cover" as this
series, adds a new 'fsdev_dax' driver for devdax. When that driver
is bound (instead of device_dax), the device is in 'famfs' mode rather
than 'devdax' mode.

References

[1] - https://famfs.org


John Groves (2):
  daxctl: Add support for famfs mode
  Add test/daxctl-famfs.sh to test famfs mode transitions:

 daxctl/device.c                | 126 ++++++++++++++--
 daxctl/json.c                  |   6 +-
 daxctl/lib/libdaxctl-private.h |   2 +
 daxctl/lib/libdaxctl.c         |  77 ++++++++++
 daxctl/lib/libdaxctl.sym       |   7 +
 daxctl/libdaxctl.h             |   3 +
 test/daxctl-famfs.sh           | 253 +++++++++++++++++++++++++++++++++
 test/meson.build               |   2 +
 8 files changed, 465 insertions(+), 11 deletions(-)
 create mode 100755 test/daxctl-famfs.sh


base-commit: 4f7a1c63b3305c97013d3c46daa6c0f76feff10d
-- 
2.49.0

