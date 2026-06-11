Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE0F40D585
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199070; cv=none; b=FBG9laFZc+dTEfIxOl+VpPMgAhdixO7yypXe3HKJB5FJadLFKTKMZgYCUYD1l6p0VwBSJyIZAY0YbUOydZouO9k9UJILmzHxn+svnWnexRMdHckSnxaMvSpahq9jUT8z1LIv3daFhLs4aSjcldtRS9xqEbYRlC0XXevtyUugc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199070; c=relaxed/simple;
	bh=1dPFrDsgw8V7mX3qiYp6cFhED8GErkHr+s9XReyzx9k=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=HjUHboR+ES+cjYMt/4Uc8ugQmCoTUl8AU8Ss/cdCEQJg648l1VZYi20fMfLjKg2oyY8XoHuPfG1Fp5jQ22UT/AUmm+GsiKGKrOxTX5o/10jinC5qiyeNvWv+r2FnrDxVFHsylaZqeVfUtquG66SLBZy6MPiDUfHllpYDxuK4quQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=q8BUBMgY; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=bNY/tLZs; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="q8BUBMgY";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="bNY/tLZs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199067;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=1dPFrDsgw8V7mX3qiYp6cFhED8GErkHr+s9XReyzx9k=;
	b=q8BUBMgYiCNw4bZrIsR3Vm0MaxgKEnZPP18H9xWHwObrvXrICJRhDGIc5f29X2tb
	xp4PWZP11QjT308PNN2B6mET+6DVcgp7FNEl+mUl8gZZf1NGqqm9xOFF//GPTF666/k
	MGhU4JKB9cMq8oHVtKXds/zB4bxDveR/cZK6wsas=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199067;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=1dPFrDsgw8V7mX3qiYp6cFhED8GErkHr+s9XReyzx9k=;
	b=bNY/tLZsrI7L/b60zTCTWMUuVexfvZr7ChithnbDA3m+nvhzPveGvbM4Xj/GxnWH
	LP43Ws3iyeG3CGxgfuY9PDVteQVxCehgCWFahQMdv8wp4u65gcKwYETi0VIIqUPOKmg
	xemqPoJMzq5I1//TzOEG+332JfBE8vHforFb/Le4=
Subject: [PATCH V5 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
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
Date: Thu, 11 Jun 2026 17:31:07 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260611173057.65868-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+cgVGG8eowYzQH2jFnHuaOQQNQ==
Thread-Topic: [PATCH V5 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
X-Wm-Sent-Timestamp: 1781199066
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.11.75

From: John Groves <john@groves.net>=0D=0A=0D=0AThis series applies bug fi=
xes (mostly found via sashiko) to the dax/fsdev=0D=0Aseries. It has been =
soaking in the famfs CI pipeline and 1) won't affect=0D=0Aanything that d=
oesn't use drivers/dax/fsdev.c, and 2) doesn't affect any=0D=0Aknown work=
loads -- although the bugs would have manifested when multi-range=0D=0ADC=
D dax devices are a thing (soon-ish).=0D=0A=0D=0AMost of the series is co=
nfined to drivers/dax/fsdev.c. Two patches touch=0D=0Ashared DAX core in =
drivers/dax/super.c: patch 7 reads holder_ops once in=0D=0Adax_holder_not=
ify_failure() to close a double-fetch NULL dereference, and=0D=0Apatch 8 =
reorders fs_put_dax() and adds a WARN_ON(). fs_put_dax() is used by=0D=0A=
ext2/ext4/erofs/xfs, but only holder-passing callers (like XFS in-tree) w=
ill=0D=0Asee a behavior change, and only a new warning if they misuse it.=
=0D=0A=0D=0AChanges since V4:=0D=0A=0D=0A- New patch 7 (dax: read holder_=
ops once in dax_holder_notify_failure()):=0D=0A  split the reader-side RE=
AD_ONCE() fix out of the fs_put_dax() patch and=0D=0A  placed it first, s=
o the fs_put_dax() patch's "a concurrent=0D=0A  dax_holder_notify_failure=
() that sees NULL ops returns -EOPNOTSUPP=0D=0A  cleanly" reasoning actua=
lly holds when it lands. dax_holder_notify_failure()=0D=0A  read holder_o=
ps twice without READ_ONCE(); a concurrent clear could make=0D=0A  the NU=
LL check pass while the indirect call dereferenced NULL. Carries=0D=0A  F=
ixes: 8012b86608552 ("dax: introduce holder for dax_device"), the commit=0D=
=0A  that introduced the unmarked double fetch. Suggested by Richard Chen=
g (and=0D=0A  the Sashiko bot).=0D=0A- Patch 2 (multi-range memory_failur=
e offset): the ->memory_failure callback=0D=0A  now walks the pagemap's o=
wn immutable range array (pgmap->ranges[]) rather=0D=0A  than dev_dax->ra=
nges[], which a concurrent sysfs mapping_store() can=0D=0A  krealloc() un=
der dax_region_rwsem while this callback holds no such lock.=0D=0A  For d=
ynamic devices the two arrays are identical, so the reported offset is=0D=
=0A  unchanged for the multi-range case this patch targets. Suggested by =
Richard=0D=0A  Cheng (and the Sashiko bot).=0D=0A- Dropped the dax_dev_ge=
t()/dax_dev_find() patch (V4 patch 8) from this=0D=0A  revision. There is=
 no in-tree caller yet; it will be sent together with the=0D=0A  famfs fi=
lesystem series that introduces the caller. (Per Richard Cheng /=0D=0A  S=
ashiko.)=0D=0A- Patch 8 (holder_ops race in fs_put_dax()): unchanged from=
 V4 (renumbered=0D=0A  from 7 to 8).=0D=0A- Collected Reviewed-by from Da=
ve Jiang on patches 4 and 6.=0D=0A=0D=0AChanges since V3:=0D=0A=0D=0A- Pa=
tch 4: Adopted Dave's suggested refactor -- factor out=0D=0A  fsdev_acqui=
re_pgmap() and defer the dev_dax->pgmap assignment until=0D=0A  probe can=
 no longer fail, replacing the goto-based cleanup. Did not=0D=0A  carry A=
lison's V3 Reviewed-by due to the rewrite.=0D=0A- Patch 5: Also remove th=
e now write-only dev_dax->virt_addr field,=0D=0A  per Dave's review.=0D=0A=
- Patch 7: Fixed the WARN_ON() to tolerate holder_data =3D=3D NULL, which=
=0D=0A  legitimately occurs when kill_dax() clears it during device remov=
al=0D=0A  under a live holder (per Dave's review). Wrong-holder calls sti=
ll=0D=0A  warn.=0D=0A- Patch 8: Kept the Fixes tag -- the exported symbol=
 itself is the=0D=0A  hazard; stable kernels carrying the export should w=
ant this fix.=0D=0A=0D=0AChanges since V2:=0D=0A=0D=0A* Patch 1 (comment =
fix): No change. Responded to Dave's question about=0D=0A  the dropped pr=
econdition -- the new comment correctly covers both=0D=0A  callers; fsdev=
_clear_folio_state() does not guarantee share=3D=3D0 before=0D=0A  callin=
g, so the old precondition was no longer universally true.=0D=0A* V2 patc=
h 2 (three fixes): Split into three separate patches (patches=0D=0A  2-4)=
 per Dave's review.=0D=0A* V2 patch 3 (two fixes): Split into two separat=
e patches (patches 5-6)=0D=0A  per Dave's review.=0D=0A* V2 patch 4 (clam=
p direct_access / remove cached_size): Dropped.=0D=0A  Dave's analysis co=
rrectly showed the claimed bug does not exist --=0D=0A  dax_pgoff_to_phys=
() already enforces that the full requested size fits=0D=0A  within a sin=
gle range before returning, making the clamp a no-op in=0D=0A  every reac=
hable path.=0D=0A* V2 patch 5 (holder_ops race): Use WRITE_ONCE() for the=
 holder_ops=0D=0A  store; add WARN_ON() on the cmpxchg result to catch wr=
ong-holder and=0D=0A  double-put API contract violations; fix the inline =
comment, which=0D=0A  incorrectly claimed dax_holder_notify_failure() con=
sults holder_ops=0D=0A  only when holder_data is non-NULL.=0D=0A* V2 patc=
h 6 (dax_dev_find): Add dax_alive() check under dax_read_lock()=0D=0A  af=
ter ilookup5() to prevent returning a device that is concurrently=0D=0A  =
being torn down by kill_dax().=0D=0A* V2 patch 7 (formatting cleanup): Dr=
op incorrect Fixes: tag; add=0D=0A  Dave's Reviewed-by.=0D=0A* The series=
 grows from 7 to 9 patches.=0D=0A=0D=0AChanges since v1:=0D=0A* Dropped m=
odes from patch 6 to fs/fuse/famfs.c and=20=0D=0A  fs/famfs/famfs_inode.c=
, which are not upstream so it broke=0D=0A  attempts to apply the series.=
 Oops...=0D=0A* Added patch 7, which addresses a previously-missed review=
 comment=0D=0A  from Jonathan - minor cleanup=0D=0A=0D=0A=0D=0A=0D=0AJohn=
 Groves (9):=0D=0A  dax: fix misleading comment about share/index union i=
n=0D=0A    dax_folio_reset_order()=0D=0A  dax/fsdev: fix multi-range offs=
et in memory_failure handler=0D=0A  dax/fsdev: clear vmemmap_shift when b=
inding static pgmap=0D=0A  dax/fsdev: don't leave a dangling dev_dax->pgm=
ap on probe failure=0D=0A  dax/fsdev: use __va(phys) for kaddr in direct_=
access=0D=0A  dax/fsdev: fail probe on invalid pgmap offset=0D=0A  dax: r=
ead holder_ops once in dax_holder_notify_failure()=0D=0A  dax: fix holder=
_ops race in fs_put_dax()=0D=0A  dax: fsdev.c minor formatting cleanup=0D=
=0A=0D=0A drivers/dax/dax-private.h |   2 -=0D=0A drivers/dax/fsdev.c    =
   | 126 +++++++++++++++++++++++++-------------=0D=0A drivers/dax/super.c=
       |  53 ++++++++++++++--=0D=0A fs/dax.c                  |  12 ++--=0D=
=0A 4 files changed, 136 insertions(+), 57 deletions(-)=0D=0A=0D=0A=0D=0A=
base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48=0D=0A--=20=0D=0A2.5=
3.0=0D=0A=0D=0A
