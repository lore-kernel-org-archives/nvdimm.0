Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849B63FC7
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 10:39:38 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8548560F48;
	Thu, 23 Sep 2021 10:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1632393578;
	bh=DVLsxmZnDQpxwky0YVgRFmmG4BlD+wPHnOnJ5BITyiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oz+8Z57v9plrxP6d9ZOec6xQ+m/LJomlpaRyNRMRvYqoGUWeS4vI/y9vmvoXVfJsd
	 jh0Awx5txUcm71s8gxxmIULO0G9hMtKyArGpB9pWz7WcJXonibXhMDhtly811ekLZS
	 yIOV8lVkGFvZZVPAhc0J8TPQChSbkbAz/EjPsCKk=
Date: Thu, 23 Sep 2021 12:39:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, antlists@youngman.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
	Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
Message-ID: <YUxZZ/UHyRTt83pW@kroah.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>
 <163239176137.2580.11220971146920860651@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163239176137.2580.11220971146920860651@noble.neil.brown.name>

On Thu, Sep 23, 2021 at 08:09:21PM +1000, NeilBrown wrote:
> On Thu, 23 Sep 2021, Coly Li wrote:
> > Hi all the kernel gurus, and folks in mailing lists,
> > 
> > This is a question about exporting 4KB+ text information via sysfs 
> > interface. I need advice on how to handle the problem.
> 
> Why do you think there is a problem?
> As documented in Documentation/admin-guide/md.rst, the truncation at 1
> page is expected and by design.

Ah, shouldn't that info also be in Documentation/ABI/ so that others can
easily find it?

thanks,

greg k-h
