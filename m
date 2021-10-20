Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434C22C81
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 14:04:00 +0000 (UTC)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
	(envelope-from <kilobyte@angband.pl>)
	id 1mdCCC-0052U7-Is; Wed, 20 Oct 2021 16:03:56 +0200
Date: Wed, 20 Oct 2021 16:03:56 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: ndctl hangs with big memmap=! fakepmem
Message-ID: <YXAhzF9qQsTPDfWU@angband.pl>
References: <YXAYPK/oZNAXBs0R@angband.pl>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXAYPK/oZNAXBs0R@angband.pl>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

On Wed, Oct 20, 2021 at 03:23:08PM +0200, Adam Borowski wrote:
> Hi!
> After bumping fakepmem sizes from 4G!20G 4G!36G to 32G!20G 32G!192G,
> ndctl hangs.  Eg, at boot:
> 
> [  725.642546] INFO: task ndctl:2486 blocked for more than 604 seconds.
> [  725.649586]       Not tainted 5.15.0-rc6-vanilla-00020-gd9abdee5fd5a #1

> [  725.677539]  ? __schedule+0x30b/0x14e0
> [  725.681975]  ? kernfs_put.part.0+0xd4/0x1a0
> [  725.686841]  ? kmem_cache_free+0x28b/0x2b0
> [  725.691622]  ? schedule+0x44/0xb0
> [  725.695622]  ? blk_mq_freeze_queue_wait+0x62/0x90
> [  725.701009]  ? do_wait_intr_irq+0xc0/0xc0
> [  725.705703]  ? del_gendisk+0xcf/0x220
> [  725.710050]  ? release_nodes+0x38/0xa0

On 5.14.14 all is fine.  Should I bisect?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Remember, the S in "IoT" stands for Security, while P stands
⢿⡄⠘⠷⠚⠋⠀ for Privacy.
⠈⠳⣄⠀⠀⠀⠀
