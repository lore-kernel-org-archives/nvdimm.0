Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A184339A7F7
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776119184; cv=none; b=EX6ky6BS8b5Z8Gb63JanCERQTnhEnx7/cdzEDkTu+rIFTPYXPjQRN1SOx8qbef3CELYBwNgOzCUGiNL7yyM9ovojlvR7q1Acs0wYN4jewNoCnSc1l+EjHsLMWz2558l9Bb0qwyxMkexfETGrOuiIjN3jW6skdT5yjDOGC0ZqPIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776119184; c=relaxed/simple;
	bh=5A7fVcPbR26mydlKiWE9R0xeDAsL1zhvxBOOqc2kDDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5AfUDphtcuNSkdlV+dlnTitF3q0ZfT0dvtdhOsik+wHw1YCyJYH62ro3cKoISee3SzwSuQY9/nfkbA3meweDTCNRk7JEh9YZLezdZSw61acaqPSWNQNJ4PIssW5FJC0Ay3az16V3gZ1H60T+zB4MOLjGEyZNyZYl6cNV2orPR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F33CF160338;
	Mon, 13 Apr 2026 22:26:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf19.hostedemail.com (Postfix) with ESMTPA id AA44720025;
	Mon, 13 Apr 2026 22:26:07 +0000 (UTC)
Date: Mon, 13 Apr 2026 17:26:06 -0500
From: John Groves <John@groves.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>, 
	John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <ad1tUMoTjlb8LCHw@groves.net>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
 <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
 <69dd576924b0f_24f910029@iweiny-mobl.notmuch>
 <69dd62eba432e_20039100b5@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69dd62eba432e_20039100b5@iweiny-mobl.notmuch>
X-Stat-Signature: 3ezap5jn6g73nfycmmsj9o9zyds13o35
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: AA44720025
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18aHdyj8CPonE2nMkMlfxQw8N6d++WsvZY=
X-HE-Tag: 1776119167-822919
X-HE-Meta: U2FsdGVkX182KUrTrOIBq57VVW5WWL50AUv3BqL4jIgvkPZooM25GEyX43V2YzPZiWCzjy1R582lpIyBAzT/7ru3gILLs8Ca1jy0vYlr1JOROvMM1Cx0aJnsvqKJ3RPabKAYHYG+s7YTGHuMvWpYz4OPIruM5JsTnisjCXFdXCc5Z9dXecVd3Pen694jsfGFbfpsgg0EnUhAaY04v+BuuBzS9K+7BjNj+gGkgpfiZeMklHZ9XH53jqz8U2onXZSm31PTHaHBvViFFdBgVnNnKTtu4TQkk42GRLep5yqnBElmiYMVamyBNJVUla6IPM7SSA0LJyrkzDTzNl7ERyKyXK63HhpwBNnEN6Hm4BZidbPmfUIZ2yOhFDuRUiTQRAyxuJKE1go4ddsmXqHuAdQrtg==

On 26/04/13 04:40PM, Ira Weiny wrote:
> Ira Weiny wrote:
> > Alison Schofield wrote:
> > > On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> > > > From: John Groves <john@groves.net>
> > > > 
> 
> [snip]
> 
> > > > 
> > > > Description:
> > > > 
> > > > This patch series introduces the required dax support for famfs.
> > > > Previous versions of the famfs series included both dax and fuse patches.
> > > > This series separates them into separate patch series' (and the fuse
> > > > series dependends on this dax series).
> > > > 
> > > > The famfs user space code can be found at [1]
> > > > 
> > > > Dax Overview:
> > > > 
> > > > This series introduces a new "famfs mode" of devdax, whose driver is
> > > > drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> > > > dax_iomap_fault() calls against a character dax instance. A dax device
> > > > now can be converted among three modes: 'system-ram', 'devdax' and
> > > > 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> > > > 
> > > > In famfs mode, a dax device initializes its pages consistent with the
> > > > fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> > > > but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> > > > dax_iomap_fault() for mmap faults.
> > > > 
> > > 
> > > Here's what I found:
> > > 
> > > famfs-v10 on 7.0-rc5 + ndctl v84:
> > > 	dax suite all pass 13/13, so no regression appears
> > > 
> > > famfs-v10 on 7.0-rc5 +
> > > (ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
> > > top 3 patches + edit daxctl-famfs.sh to use cxl-test:
> > > 
> > > 	existing dax suite keeps passing
> > > 	daxctl-famfs.sh oops w the new test at # Restore original mode"
> > > 	seems easy to repoduce, maybe cannot go back to system-ram???
> > 
> > John have you been able to reproduce this?
> > 
> > Ira
> 
> John I've found a different crash with the daxctl-famfs.sh test.  See
> below.
> 
> I got the ndctl repo with the test from Alison.
> 
> I'm not at all clear what is happening at this point...
> 
> Ira
> 
> <crash>
> 
> [  519.007691] BUG: TASK stack guard page was hit at ffffc90001767fc8 (stack is ffffc90001768000..ffffc9000176c000)
> [  519.007694] Oops: stack guard page: 0000 [#1] SMP NOPTI
> [  519.007697] CPU: 0 UID: 0 PID: 1465 Comm: daxctl Tainted: G           O        7.0.0-rc6ira+ #68 PREEMPT(full)
> [  519.007699] Tainted: [O]=OOT_MODULE
> [  519.007700] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20250812-19.fc42 08/12/2025
> [  519.007701] RIP: 0010:sprintf+0xc/0x50
> [  519.007709] Code: 24 10 e8 37 f8 ff ff c9 c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 83 ec 48 48 8d 45 10 <48>
>  89 54 24 28 48 89 f2 be ff ff ff 7f 48 89 4c 24 30 48 89 e1 48
> [  519.007710] RSP: 0018:ffffc90001767fd0 EFLAGS: 00010282
> [  519.007712] RAX: ffffc90001768028 RBX: ffffc90001768068 RCX: 0000000000001e08
> [  519.007712] RDX: 0000000000000207 RSI: ffffffff82abab1c RDI: ffffc90001768068
> [  519.007713] RBP: ffffc90001768018 R08: 0000000000000000 R09: 0000000000000001
> [  519.007713] R10: ffffc90001768110 R11: 0000000000000002 R12: 0000000000000800
> [  519.007714] R13: ffffc90001768068 R14: 0000000000000000 R15: ffffffff839c71c0
> [  519.007715] FS:  00007fb94b807c80(0000) GS:ffff8880f9e9c000(0000) knlGS:0000000000000000
> [  519.007717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  519.007717] CR2: ffffc90001767fc8 CR3: 0000000077d2e005 CR4: 0000000000770ef0
> [  519.007720] PKRU: 55555554
> [  519.007721] Call Trace:
> [  519.007722]  <TASK>
> [  519.007723]  info_print_prefix+0xc0/0xe0
> [  519.007728]  record_print_text+0x58/0x2d0
> [  519.007730]  printk_get_next_message+0xd8/0x220
> [  519.007733]  console_flush_one_record+0x1a5/0x390
> [  519.007735]  console_unlock+0x5a/0xe0
> [  519.007737]  vprintk_emit+0x2e8/0x340
> [  519.007738]  _printk+0x48/0x50
> [  519.007741]  ? printk_get_next_message+0x70/0x220
> [  519.007743]  __dump_page.cold+0x3c/0x331
> [  519.007746]  ? dump_page+0x1b/0x30
> [  519.007748]  dump_page+0x1b/0x30
> [  519.007749]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007751]  get_pfnblock_migratetype+0xa/0x20
> [  519.007753]  __dump_page.cold+0x1c6/0x331
> [  519.007755]  ? dump_page+0x1b/0x30
> [  519.007756]  dump_page+0x1b/0x30
> [  519.007756]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007757]  get_pfnblock_migratetype+0xa/0x20
> [  519.007758]  __dump_page.cold+0x1c6/0x331
> [  519.007760]  ? dump_page+0x1b/0x30
> [  519.007761]  dump_page+0x1b/0x30
> [  519.007761]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007762]  get_pfnblock_migratetype+0xa/0x20
> [  519.007763]  __dump_page.cold+0x1c6/0x331
> [  519.007765]  ? dump_page+0x1b/0x30
> [  519.007765]  dump_page+0x1b/0x30
> [  519.007766]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007767]  get_pfnblock_migratetype+0xa/0x20
> [  519.007772]  __dump_page.cold+0x1c6/0x331
> [  519.007774]  ? dump_page+0x1b/0x30
> [  519.007775]  dump_page+0x1b/0x30
> [  519.007775]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007776]  get_pfnblock_migratetype+0xa/0x20
> [  519.007777]  __dump_page.cold+0x1c6/0x331
> [  519.007779]  ? dump_page+0x1b/0x30
> [  519.007780]  dump_page+0x1b/0x30
> [  519.007780]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007781]  get_pfnblock_migratetype+0xa/0x20
> [  519.007782]  __dump_page.cold+0x1c6/0x331
> [  519.007784]  ? dump_page+0x1b/0x30
> [  519.007785]  dump_page+0x1b/0x30
> [  519.007785]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007786]  get_pfnblock_migratetype+0xa/0x20
> [  519.007787]  __dump_page.cold+0x1c6/0x331
> [  519.007789]  ? dump_page+0x1b/0x30
> [  519.007790]  dump_page+0x1b/0x30
> [  519.007790]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007791]  get_pfnblock_migratetype+0xa/0x20
> [  519.007792]  __dump_page.cold+0x1c6/0x331
> [  519.007794]  ? dump_page+0x1b/0x30
> [  519.007795]  dump_page+0x1b/0x30
> [  519.007795]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007796]  get_pfnblock_migratetype+0xa/0x20
> [  519.007797]  __dump_page.cold+0x1c6/0x331
> [  519.007799]  ? dump_page+0x1b/0x30
> [  519.007800]  dump_page+0x1b/0x30
> [  519.007800]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007801]  get_pfnblock_migratetype+0xa/0x20
> [  519.007802]  __dump_page.cold+0x1c6/0x331
> [  519.007804]  ? dump_page+0x1b/0x30
> [  519.007805]  dump_page+0x1b/0x30
> [  519.007808]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007809]  get_pfnblock_migratetype+0xa/0x20
> [  519.007810]  __dump_page.cold+0x1c6/0x331
> [  519.007812]  ? dump_page+0x1b/0x30
> [  519.007813]  dump_page+0x1b/0x30
> [  519.007813]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007814]  get_pfnblock_migratetype+0xa/0x20
> [  519.007815]  __dump_page.cold+0x1c6/0x331
> [  519.007817]  ? dump_page+0x1b/0x30
> [  519.007818]  dump_page+0x1b/0x30
> [  519.007818]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007819]  get_pfnblock_migratetype+0xa/0x20
> [  519.007820]  __dump_page.cold+0x1c6/0x331
> [  519.007822]  ? dump_page+0x1b/0x30
> [  519.007823]  dump_page+0x1b/0x30
> [  519.007824]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007824]  get_pfnblock_migratetype+0xa/0x20
> [  519.007825]  __dump_page.cold+0x1c6/0x331
> [  519.007827]  ? dump_page+0x1b/0x30
> [  519.007828]  dump_page+0x1b/0x30
> [  519.007829]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007829]  get_pfnblock_migratetype+0xa/0x20
> [  519.007830]  __dump_page.cold+0x1c6/0x331
> [  519.007833]  ? dump_page+0x1b/0x30
> [  519.007833]  dump_page+0x1b/0x30
> [  519.007834]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007834]  get_pfnblock_migratetype+0xa/0x20
> [  519.007835]  __dump_page.cold+0x1c6/0x331
> [  519.007838]  ? dump_page+0x1b/0x30
> [  519.007838]  dump_page+0x1b/0x30
> [  519.007839]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007840]  get_pfnblock_migratetype+0xa/0x20
> [  519.007841]  __dump_page.cold+0x1c6/0x331
> [  519.007843]  ? dump_page+0x1b/0x30
> [  519.007843]  dump_page+0x1b/0x30
> [  519.007844]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007845]  get_pfnblock_migratetype+0xa/0x20
> [  519.007846]  __dump_page.cold+0x1c6/0x331
> [  519.007848]  ? dump_page+0x1b/0x30
> [  519.007849]  dump_page+0x1b/0x30
> [  519.007849]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007850]  get_pfnblock_migratetype+0xa/0x20
> [  519.007851]  __dump_page.cold+0x1c6/0x331
> [  519.007853]  ? dump_page+0x1b/0x30
> [  519.007854]  dump_page+0x1b/0x30
> [  519.007854]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007855]  get_pfnblock_migratetype+0xa/0x20
> [  519.007856]  __dump_page.cold+0x1c6/0x331
> [  519.007858]  ? dump_page+0x1b/0x30
> [  519.007859]  dump_page+0x1b/0x30
> [  519.007859]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007860]  get_pfnblock_migratetype+0xa/0x20
> [  519.007861]  __dump_page.cold+0x1c6/0x331
> [  519.007863]  ? dump_page+0x1b/0x30
> [  519.007864]  dump_page+0x1b/0x30
> [  519.007864]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007865]  get_pfnblock_migratetype+0xa/0x20
> [  519.007866]  __dump_page.cold+0x1c6/0x331
> [  519.007868]  ? dump_page+0x1b/0x30
> [  519.007869]  dump_page+0x1b/0x30
> [  519.007869]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007870]  get_pfnblock_migratetype+0xa/0x20
> [  519.007871]  __dump_page.cold+0x1c6/0x331
> [  519.007873]  ? dump_page+0x1b/0x30
> [  519.007874]  dump_page+0x1b/0x30
> [  519.007874]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007875]  get_pfnblock_migratetype+0xa/0x20
> [  519.007876]  __dump_page.cold+0x1c6/0x331
> [  519.007878]  ? dump_page+0x1b/0x30
> [  519.007879]  dump_page+0x1b/0x30
> [  519.007880]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007880]  get_pfnblock_migratetype+0xa/0x20
> [  519.007881]  __dump_page.cold+0x1c6/0x331
> [  519.007883]  ? dump_page+0x1b/0x30
> [  519.007884]  dump_page+0x1b/0x30
> [  519.007885]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007885]  get_pfnblock_migratetype+0xa/0x20
> [  519.007886]  __dump_page.cold+0x1c6/0x331
> [  519.007889]  ? dump_page+0x1b/0x30
> [  519.007889]  dump_page+0x1b/0x30
> [  519.007890]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007890]  get_pfnblock_migratetype+0xa/0x20
> [  519.007891]  __dump_page.cold+0x1c6/0x331
> [  519.007894]  ? dump_page+0x1b/0x30
> [  519.007894]  dump_page+0x1b/0x30
> [  519.007895]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007895]  get_pfnblock_migratetype+0xa/0x20
> [  519.007896]  __dump_page.cold+0x1c6/0x331
> [  519.007899]  ? dump_page+0x1b/0x30
> [  519.007899]  dump_page+0x1b/0x30
> [  519.007900]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007900]  get_pfnblock_migratetype+0xa/0x20
> [  519.007901]  __dump_page.cold+0x1c6/0x331
> [  519.007904]  ? dump_page+0x1b/0x30
> [  519.007904]  dump_page+0x1b/0x30
> [  519.007905]  __get_pfnblock_flags_mask+0x6c/0xe0
> [  519.007905]  get_pfnblock_migratetype+0xa/0x20
> [  519.007906]  __dump_page.cold+0x1c6/0x331
> [  519.007907]  ? do_file_open+0xbe/0x150
> [  519.007910]  ? stack_depot_save_flags+0x24/0x910
> [  519.007918]  ? dump_page+0x1b/0x30
> [  519.007919]  dump_page+0x1b/0x30
> [  519.007920]  memmap_init_range+0x2f6/0x310
> [  519.007922]  move_pfn_range_to_zone+0xee/0x220
> [  519.007924]  mhp_init_memmap_on_memory+0x23/0xb0
> [  519.007926]  memory_subsys_online+0x122/0x1a0
> [  519.007929]  device_online+0x49/0x80
> [  519.007931]  state_store+0x8e/0xa0
> [  519.007932]  kernfs_fop_write_iter+0x136/0x1f0
> [  519.007935]  vfs_write+0x205/0x460
> [  519.007937]  ksys_write+0x57/0xd0
> [  519.007938]  do_syscall_64+0x106/0x5f0
> [  519.007940]  ? irqentry_exit+0x6c/0x520
> [  519.007941]  ? exc_page_fault+0x66/0x180
> [  519.007942]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  519.007944] RIP: 0033:0x7fb94ba3473e
> [  519.007946] Code: 4d 89 d8 e8 d4 bc 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9>
>  c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
> [  519.007946] RSP: 002b:00007fff47c8ddd0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [  519.007948] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb94ba3473e
> [  519.007948] RDX: 000000000000000f RSI: 00007fb94bc21a3e RDI: 0000000000000004
> [  519.007949] RBP: 00007fff47c8dde0 R08: 0000000000000000 R09: 0000000000000000
> [  519.007949] R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff47c8e3f8
> [  519.007950] R13: 0000000000000006 R14: 00007fb94bc67000 R15: 0000000000413d88
> [  519.007951]  </TASK>
> [  519.007951] Modules linked in: cxl_test(O) cxl_acpi(O) device_dax(O) fsdev_dax kmem nd_pmem(O) nd_btt(O) cxl_pmu dax_cxl dax_pmem(O) cxl_pci nd_e820
> (O) nfit(O) cxl_mock_mem(O) cxl_pmem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) libnvdimm(O) nfit_test_iomap(O) cxl_core(O) fwctl [last unloaded: cxl_acpi(O
> )]
> [  519.007962] ---[ end trace 0000000000000000 ]---
> [  519.007963] RIP: 0010:sprintf+0xc/0x50
> [  519.007964] Code: 24 10 e8 37 f8 ff ff c9 c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 83 ec 48 48 8d 45 10 <48>
>  89 54 24 28 48 89 f2 be ff ff ff 7f 48 89 4c 24 30 48 89 e1 48
> [  519.007965] RSP: 0018:ffffc90001767fd0 EFLAGS: 00010282
> [  519.007966] RAX: ffffc90001768028 RBX: ffffc90001768068 RCX: 0000000000001e08
> [  519.007966] RDX: 0000000000000207 RSI: ffffffff82abab1c RDI: ffffc90001768068
> [  519.007967] RBP: ffffc90001768018 R08: 0000000000000000 R09: 0000000000000001
> [  519.007967] R10: ffffc90001768110 R11: 0000000000000002 R12: 0000000000000800
> [  519.007967] R13: ffffc90001768068 R14: 0000000000000000 R15: ffffffff839c71c0
> [  519.007968] FS:  00007fb94b807c80(0000) GS:ffff8880f9e9c000(0000) knlGS:0000000000000000
> [  519.007969] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  519.007969] CR2: ffffc90001767fc8 CR3: 0000000077d2e005 CR4: 0000000000770ef0
> [  519.007971] PKRU: 55555554
> [  519.007972] Kernel panic - not syncing: Fatal exception in interrupt
> [  519.008404] Kernel Offset: disabled
> [  519.083400] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Dang. Obviously runaway recursion; I don't recognize anything in
the stack, but will start trying to reproduce it.

John

