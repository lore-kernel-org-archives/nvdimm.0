Received: from a11-132.smtp-out.amazonses.com (a11-132.smtp-out.amazonses.com [54.240.11.132])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5C408033
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539542; cv=none; b=e4BL2jG5cPmYwxAvr6tQvQeIaRwCoq+x/jhJ+EfKDpsWSDdNG3/qsHhB8zYd6SzojljvmBksGqWZDqr3SpYe38iUVG5P7FQz/suGU2SNn64V+VVF7NlPxCbdzK4LyAtddGVO1e3CtJBUz3VQJk31L48SsYfxPGvdlU8OYO3dOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539542; c=relaxed/simple;
	bh=M2y4CTbNfe9uudvCRjjTAPYC7EJo/vzu/b9Trttydik=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=ewpyA62um2jlpgSCfMB5KfV3+wb0MncHjaZFSQVTxg7blEz/k2h3tnHC/0g7s+QMfQTLQ/S4cqlQf3UHTYSNHyTgzVtaueL6j6LdeDQW3mQI9k8pjnyDN4BiQqMrakezlAdBtPTGJq2YHvjM6fSwEN7iWGo8URT1d+1ymZDwVEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=mC0Z0oS6; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=EW+dgA1f; arc=none smtp.client-ip=54.240.11.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="mC0Z0oS6";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="EW+dgA1f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539539;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=M2y4CTbNfe9uudvCRjjTAPYC7EJo/vzu/b9Trttydik=;
	b=mC0Z0oS6O+fyzQlcxeMyKgA9n1My9lDu+u8EIYY/rBBzxJzSjHwgzTz72zxAvE/B
	47y5idJ0gW4q5RyoGQqdTU5mEeXKly8p2AgKewP+VwVPPxHtoUd54+WKCvKvfKvTqZQ
	2FnqKEk7E85dmTognReu36zgSCbOxOPytze0RLpQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539539;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=M2y4CTbNfe9uudvCRjjTAPYC7EJo/vzu/b9Trttydik=;
	b=EW+dgA1fxIUrB2IfXqEC53tkiCadYQqZHCyV4ZAo3kLkvoArMZ8x5FDsnyMQUJ+X
	ExKM+YirHeufF2II6r04rdXxmQxhxEcU9R2W69QfY4fVS1pJR1ru1sEzRVsMwPnBcb6
	IElMLZLOjprXk9rL54WqZMgnfpDKHqsTEs/mnIY8=
Subject: [PATCH V6 0/10] Fixes to the previously-merged drivers/dax/fsdev
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
Date: Mon, 15 Jun 2026 16:05:39 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260615160531.17432-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSw==
Thread-Topic: [PATCH V6 0/10] Fixes to the previously-merged
 drivers/dax/fsdev series
X-Wm-Sent-Timestamp: 1781539538
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.132

From: John Groves <john@groves.net>=0D=0A=0D=0AThis series applies bug fi=
xes (mostly found via sashiko) to the dax/fsdev=0D=0Aseries. It has been =
soaking in the famfs CI pipeline and 1) won't affect=0D=0Aanything that d=
oesn't use drivers/dax/fsdev.c, and 2) doesn't affect any=0D=0Aknown work=
loads -- although the bugs would have manifested when multi-range=0D=0ADC=
D dax devices are a thing (soon-ish).=0D=0A=0D=0AMost of the series is co=
nfined to drivers/dax/fsdev.c. Two patches touch=0D=0Ashared DAX core in =
drivers/dax/super.c: patch 8 reads holder_ops once in=0D=0Adax_holder_not=
ify_failure() to close a double-fetch NULL dereference, and=0D=0Apatch 9 =
reorders fs_put_dax() and adds a WARN_ON(). fs_put_dax() is used by=0D=0A=
ext2/ext4/erofs/xfs, but only holder-passing callers (like XFS in-tree) w=
ill=0D=0Asee a behavior change, and only a new warning if they misuse it.=
=0D=0A=0D=0AChanges since V5:=0D=0A=0D=0A- Patch 2 (multi-range memory_fa=
ilure offset): reverted to walking=0D=0A  dev_dax->ranges[]. V5 walked th=
e immutable pgmap->ranges[] to avoid the=0D=0A  lockless read of dev_dax-=
>ranges[], but that regressed static devices:=0D=0A  pgmap->ranges[0].sta=
rt can sit data_offset below the data start, so the=0D=0A  reported failu=
re offset came out data_offset too high and the holder=0D=0A  would act o=
n the wrong blocks. dev_dax->ranges[] gives the correct base=0D=0A  (rang=
es[0].start, the device data start) for both static and dynamic=0D=0A  de=
vices. The lockless read is pre-existing -- the original single-range=0D=0A=
  code read dev_dax->ranges[0] locklessly too -- so this adds no new race=
;=0D=0A  closing it is left to a separate change. (Richard Cheng spotted =
the=0D=0A  static regression.)=0D=0A=0D=0A- New patch 5 (dax/fsdev: clear=
 pgmap ops and owner on unbind): fsdev sets=0D=0A  pgmap->ops and pgmap->=
owner at probe but nothing ever cleared them. For a=0D=0A  static device =
the pgmap is shared and long-lived, so after fsdev unbind=0D=0A  the stal=
e fsdev ops survive; a later rebind to device_dax or an rmmod of=0D=0A  f=
sdev_dax could then dispatch memory_failure through a stale -- and=0D=0A =
 possibly freed -- handler. Add a devm action that clears both on unbind,=
=0D=0A  symmetric with setting them at probe. Suggested by Richard Cheng.=
=0D=0A=0D=0A- Patch 8 (read holder_ops once): reworded the commit message=
 and the code=0D=0A  comment to name only fs_put_dax() as the racing clea=
rer. kill_dax()=0D=0A  clears holder_ops only after synchronize_srcu(), s=
o it cannot race a=0D=0A  reader under dax_read_lock(); fs_put_dax() does=
 no such synchronization.=0D=0A  Collected Reviewed-by from Richard Cheng=
=2E=0D=0A=0D=0A- Patch 7 (fail probe on invalid pgmap offset): collected =
Reviewed-by from=0D=0A  Pankaj Gupta.=0D=0A=0D=0A- Rebased onto the v7.1 =
release (V5 was based on v7.1-rc7); no other change=0D=0A  from the rebas=
e.=0D=0A=0D=0AChanges since V4:=0D=0A=0D=0A- New patch 7 (dax: read holde=
r_ops once in dax_holder_notify_failure()):=0D=0A  split the reader-side =
READ_ONCE() fix out of the fs_put_dax() patch and=0D=0A  placed it first,=
 so the fs_put_dax() patch's "a concurrent=0D=0A  dax_holder_notify_failu=
re() that sees NULL ops returns -EOPNOTSUPP=0D=0A  cleanly" reasoning act=
ually holds when it lands. dax_holder_notify_failure()=0D=0A  read holder=
_ops twice without READ_ONCE(); a concurrent clear could make=0D=0A  the =
NULL check pass while the indirect call dereferenced NULL. Carries=0D=0A =
 Fixes: 8012b86608552 ("dax: introduce holder for dax_device"), the commi=
t=0D=0A  that introduced the unmarked double fetch. Suggested by Richard =
Cheng (and=0D=0A  the Sashiko bot).=0D=0A- Patch 2 (multi-range memory_fa=
ilure offset): the ->memory_failure callback=0D=0A  now walks the pagemap=
's own immutable range array (pgmap->ranges[]) rather=0D=0A  than dev_dax=
->ranges[], which a concurrent sysfs mapping_store() can=0D=0A  krealloc(=
) under dax_region_rwsem while this callback holds no such lock.=0D=0A  F=
or dynamic devices the two arrays are identical, so the reported offset i=
s=0D=0A  unchanged for the multi-range case this patch targets. Suggested=
 by Richard=0D=0A  Cheng (and the Sashiko bot).=0D=0A- Dropped the dax_de=
v_get()/dax_dev_find() patch (V4 patch 8) from this=0D=0A  revision. Ther=
e is no in-tree caller yet; it will be sent together with the=0D=0A  famf=
s filesystem series that introduces the caller. (Per Richard Cheng /=0D=0A=
  Sashiko.)=0D=0A- Patch 8 (holder_ops race in fs_put_dax()): unchanged f=
rom V4 (renumbered=0D=0A  from 7 to 8).=0D=0A- Collected Reviewed-by from=
 Dave Jiang on patches 4 and 6.=0D=0A=0D=0AChanges since V3:=0D=0A=0D=0A-=
 Patch 4: Adopted Dave's suggested refactor -- factor out=0D=0A  fsdev_ac=
quire_pgmap() and defer the dev_dax->pgmap assignment until=0D=0A  probe =
can no longer fail, replacing the goto-based cleanup. Did not=0D=0A  carr=
y Alison's V3 Reviewed-by due to the rewrite.=0D=0A- Patch 5: Also remove=
 the now write-only dev_dax->virt_addr field,=0D=0A  per Dave's review.=0D=
=0A- Patch 7: Fixed the WARN_ON() to tolerate holder_data =3D=3D NULL, wh=
ich=0D=0A  legitimately occurs when kill_dax() clears it during device re=
moval=0D=0A  under a live holder (per Dave's review). Wrong-holder calls =
still=0D=0A  warn.=0D=0A- Patch 8: Kept the Fixes tag -- the exported sym=
bol itself is the=0D=0A  hazard; stable kernels carrying the export shoul=
d want this fix.=0D=0A=0D=0AChanges since V2:=0D=0A=0D=0A* Patch 1 (comme=
nt fix): No change. Responded to Dave's question about=0D=0A  the dropped=
 precondition -- the new comment correctly covers both=0D=0A  callers; fs=
dev_clear_folio_state() does not guarantee share=3D=3D0 before=0D=0A  cal=
ling, so the old precondition was no longer universally true.=0D=0A* V2 p=
atch 2 (three fixes): Split into three separate patches (patches=0D=0A  2=
-4) per Dave's review.=0D=0A* V2 patch 3 (two fixes): Split into two sepa=
rate patches (patches 5-6)=0D=0A  per Dave's review.=0D=0A* V2 patch 4 (c=
lamp direct_access / remove cached_size): Dropped.=0D=0A  Dave's analysis=
 correctly showed the claimed bug does not exist --=0D=0A  dax_pgoff_to_p=
hys() already enforces that the full requested size fits=0D=0A  within a =
single range before returning, making the clamp a no-op in=0D=0A  every r=
eachable path.=0D=0A* V2 patch 5 (holder_ops race): Use WRITE_ONCE() for =
the holder_ops=0D=0A  store; add WARN_ON() on the cmpxchg result to catch=
 wrong-holder and=0D=0A  double-put API contract violations; fix the inli=
ne comment, which=0D=0A  incorrectly claimed dax_holder_notify_failure() =
consults holder_ops=0D=0A  only when holder_data is non-NULL.=0D=0A* V2 p=
atch 6 (dax_dev_find): Add dax_alive() check under dax_read_lock()=0D=0A =
 after ilookup5() to prevent returning a device that is concurrently=0D=0A=
  being torn down by kill_dax().=0D=0A* V2 patch 7 (formatting cleanup): =
Drop incorrect Fixes: tag; add=0D=0A  Dave's Reviewed-by.=0D=0A* The seri=
es grows from 7 to 9 patches.=0D=0A=0D=0AChanges since v1:=0D=0A* Dropped=
 modes from patch 6 to fs/fuse/famfs.c and=0D=0A  fs/famfs/famfs_inode.c,=
 which are not upstream so it broke=0D=0A  attempts to apply the series. =
Oops...=0D=0A* Added patch 7, which addresses a previously-missed review =
comment=0D=0A  from Jonathan - minor cleanup=0D=0A=0D=0AJohn Groves (10):=
=0D=0A  dax: fix misleading comment about share/index union in=0D=0A    d=
ax_folio_reset_order()=0D=0A  dax/fsdev: fix multi-range offset in memory=
_failure handler=0D=0A  dax/fsdev: clear vmemmap_shift when binding stati=
c pgmap=0D=0A  dax/fsdev: don't leave a dangling dev_dax->pgmap on probe =
failure=0D=0A  dax/fsdev: clear pgmap ops and owner on unbind=0D=0A  dax/=
fsdev: use __va(phys) for kaddr in direct_access=0D=0A  dax/fsdev: fail p=
robe on invalid pgmap offset=0D=0A  dax: read holder_ops once in dax_hold=
er_notify_failure()=0D=0A  dax: fix holder_ops race in fs_put_dax()=0D=0A=
  dax: fsdev.c minor formatting cleanup=0D=0A=0D=0A drivers/dax/dax-priva=
te.h |   2 -=0D=0A drivers/dax/fsdev.c       | 148 ++++++++++++++++++++++=
++++------------=0D=0A drivers/dax/super.c       |  54 ++++++++++++--=0D=0A=
 fs/dax.c                  |  12 ++--=0D=0A 4 files changed, 159 insertio=
ns(+), 57 deletions(-)=0D=0A=0D=0A=0D=0Abase-commit: 8cd9520d35a6c38db656=
7e97dd93b1f11f185dc6=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
