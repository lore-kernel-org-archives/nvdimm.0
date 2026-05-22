Received: from a48-182.smtp-out.amazonses.com (a48-182.smtp-out.amazonses.com [54.240.48.182])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AEC37D108
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477569; cv=none; b=Ngm34vr/gPtLZQbJybDYdvU8hhB/AN+4p+fvqp35uqwE8+yZqWXBXLqjOj7fCXDWI+9D3JdeYbpNe9zWjfioDM2AyL1Xuaf1l7+a5m7TidwvI+F5BBVcazBIPhfFCzyfsRq6Y9z3bJj2e18AIkTtrlxuKZPPHJQI/Ie/9vFvjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477569; c=relaxed/simple;
	bh=m4BBAeCvEGhCyYkKg85c6DxP0u0ZmFFYqyIVF/PHpG4=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=g5SYbRTq17uspsJUkqvIlu9fFwIDsvyPGigiV4ZjK2aBljxV6YkH1XoShxBWd/BJ/H3WZGJ9pX5tKs7KehRm/6IcxjKrzppLiHhQxbd/FemqE8uDY+4m2kEHYiCt0mOqztef9loTjnqAW8EK/JSCVgKZDZseYp9Tpwp28dszsL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=vBcj2UYi; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=M8Dawh4A; arc=none smtp.client-ip=54.240.48.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="vBcj2UYi";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="M8Dawh4A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477563;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=m4BBAeCvEGhCyYkKg85c6DxP0u0ZmFFYqyIVF/PHpG4=;
	b=vBcj2UYi/kIiwafnJyQprRR0p1ZwyDdjDw/88enfK4eDD3wrdPjSwmhIK9mjD/Wi
	48Udpy/LYQuVwWamhzndVBOYy0XdDcfU1sGqS/CAQ5ZHeqmC53LaputYdAdijuUem80
	QkCXUIZflLlm/bHqo2ZL6YfE4WoaP87C1/nL0YCQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477563;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=m4BBAeCvEGhCyYkKg85c6DxP0u0ZmFFYqyIVF/PHpG4=;
	b=M8Dawh4AiGsy+VRHefHXT7pXxQVqHT+/InnDTTCgKMwlEv3qprwQQiPPWqe4Rh54
	cde/Twxhk0hzTcuyPFEaHf0kvaHLs2yhiDs/joSC8Z6K382H1/dZotthKhca96RSy8Y
	HR3Dbwr42ihg3Dy2fkEpsa4bde+LZ1IciPCHszdw=
Subject: [PATCH V2 5/7] dax: fix holder_ops race in fs_put_dax()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Fri, 22 May 2026 19:19:23 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com> 
 <20260522191917.79204-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4gAACmH8
Thread-Topic: [PATCH V2 5/7] dax: fix holder_ops race in fs_put_dax()
X-Wm-Sent-Timestamp: 1779477561
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e5120c6c2-6fee7a58-7fb8-4c80-a229-4b5573e0e2c0-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.48.182

From: John Groves <John@Groves.net>=0D=0A=0D=0AClear holder_ops before ho=
lder_data so that a concurrent fs_dax_get()=0D=0Acannot have its newly in=
stalled holder_ops overwritten. Also add a=0D=0Akerneldoc comment documen=
ting that fs_put_dax() must only be called=0D=0Aby the current holder.=0D=
=0A=0D=0AFixes: eec38f5d86d27 ("dax: add fs_dax_get() for devdax")=0D=0AS=
igned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/su=
per.c | 24 ++++++++++++++++++++++--=0D=0A 1 file changed, 22 insertions(+=
), 2 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/super.c b/drivers/d=
ax/super.c=0D=0Aindex 25cf99dd9360b..fa1d2a6eb2408 100644=0D=0A--- a/driv=
ers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -116,11 +116,31 @@=
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);=0D=0A=20=0D=0A #if IS_ENABLED(CON=
FIG_FS_DAX)=0D=0A=20=0D=0A+/**=0D=0A+ * fs_put_dax() - release holder own=
ership of a dax_device=0D=0A+ * @dax_dev: dax device to release (may be N=
ULL)=0D=0A+ * @holder: the holder pointer previously passed to fs_dax_get=
() or=0D=0A+ *          fs_dax_get_by_bdev(); must match exactly, as it i=
s used=0D=0A+ *          in a cmpxchg to atomically release ownership=0D=0A=
+ *=0D=0A+ * Must only be called by the current holder. Clears holder_ops=
 before=0D=0A+ * holder_data to avoid a race where a concurrent fs_dax_ge=
t() could have=0D=0A+ * its newly installed holder_ops overwritten.=0D=0A=
+ */=0D=0A void fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=0A=
 {=0D=0A-=09if (dax_dev && holder &&=0D=0A-=09    cmpxchg(&dax_dev->holde=
r_data, holder, NULL) =3D=3D holder)=0D=0A+=09if (dax_dev && holder) {=0D=
=0A+=09=09/*=0D=0A+=09=09 * Clear holder_ops before holder_data so that a=
 concurrent=0D=0A+=09=09 * fs_dax_get() cannot have its newly installed h=
older_ops=0D=0A+=09=09 * overwritten. holder_ops is only consulted when h=
older_data=0D=0A+=09=09 * is non-NULL, so clearing ops first is safe =E2=80=
=94 any in-flight=0D=0A+=09=09 * holder_notify_failure() will see the old=
 holder_data with=0D=0A+=09=09 * NULL ops (a no-op) rather than new ops w=
ith wrong context.=0D=0A+=09=09 */=0D=0A =09=09dax_dev->holder_ops =3D NU=
LL;=0D=0A+=09=09cmpxchg(&dax_dev->holder_data, holder, NULL);=0D=0A+=09}=0D=
=0A =09put_dax(dax_dev);=0D=0A }=0D=0A EXPORT_SYMBOL_GPL(fs_put_dax);=0D=0A=
--=20=0D=0A2.53.0=0D=0A=0D=0A
