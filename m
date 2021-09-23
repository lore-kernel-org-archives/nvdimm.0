Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776513FC7
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 06:09:24 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36D686115A;
	Thu, 23 Sep 2021 06:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1632377364;
	bh=AtQTlBMq8A/bwaK7+ylBueGzhso1tQLgQ9j89A9siLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xwh+uEATwHdqF7NmcBcEwAddya1IyFP+R7sOYr0qkdwRpXqEYNk2n8/6crf/qYPRG
	 9S3d4YTjpQNOSd/EsUQ+f0msDjM2Ak/mFCYS5r/Uxwhtz4YdeWGl3bOJ0C+eh27CB+
	 R2JcmU8tVdILFYXJEi5TAI/8yscs9h95G5+TIQn0=
Date: Thu, 23 Sep 2021 08:08:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
	Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
Message-ID: <YUwZ95Z+L5M3aZ9V@kroah.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>

On Thu, Sep 23, 2021 at 01:59:28PM +0800, Coly Li wrote:
> Hi all the kernel gurus, and folks in mailing lists,
> 
> This is a question about exporting 4KB+ text information via sysfs
> interface. I need advice on how to handle the problem.

Please do not do that.  Seriously, that is not what sysfs is for, and is
an abuse of it.

sysfs is for "one value per file" and should never even get close to a
4kb limit.  If it does, you are doing something really really wrong and
should just remove that sysfs file from the system and redesign your
api.

> Recently I work on the bad blocks API (block/badblocks.c) improvement, there
> is a sysfs file to export the bad block ranges for me raid. E.g for a md
> raid1 device, file
>     /sys/block/md0/md/rd0/bad_blocks
> may contain the following text content,
>     64 32
>    128 8

Ick, again, that's not ok at all.  sysfs files should never have to be
parsed like this.

thanks,

greg k-h
