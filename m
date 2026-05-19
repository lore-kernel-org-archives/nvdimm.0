Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470504D8D8D
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193157; cv=none; b=B/3/pxoDBKBiNRxf1aw+yPmeSOxV1FcIyovAKrKCEPiu+E2om2aGW8Cmav7EC/3sXjNQquT5NdBOvYRvuRprBvYoXdxi5GI1Gh9cEljmR/XPwmYISxU0SrLaJ30mqEcjS2EX+JOadggKusBDnLRoiYitE4o+roJuTgKj8h3BrFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193157; c=relaxed/simple;
	bh=FVUAOKxJ4/gQjtoEIOeX2f6c+LaBaXG9nL028JyEamU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K55+0Wm4GogbHtbdOu3GUOrUJg1zm+xI9Az8dpGvIB+gCCgQFtOZvSA1OhkOqiNh9UT1Hr14IDDMcRjcewItyt9yfs3NBXhID6Z/YpH7/ID6hzQthptKjH6DAPmP2/AJJlq9b47Xyo7NZAaC9DFz29pSeYPPeic9YlpaliyN8MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6DE91C0F18;
	Tue, 19 May 2026 12:19:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf12.hostedemail.com (Postfix) with ESMTPA id E7B9319;
	Tue, 19 May 2026 12:19:09 +0000 (UTC)
Date: Tue, 19 May 2026 07:19:08 -0500
From: John Groves <John@groves.net>
To: John Groves <john@jagalactic.com>
Cc: Dan Williams <djbw@kernel.org>, John Groves <jgroves@micron.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Fixes to the previously-merged drivers/dax/fsdev
 series
Message-ID: <agxU6hGczRT2DSFD@groves.net>
References: <20260518213452.31205-1-john@jagalactic.com>
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: E7B9319
X-Stat-Signature: 5kxpnegw4c6uyiky9yxy64ydg3r5qgid
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+OXa13HFXgL+p58q8pzyuxChQey+jLsT8=
X-HE-Tag: 1779193149-569511
X-HE-Meta: U2FsdGVkX19yeEv3a442bfJ6Yp0ZhKTvBQTuk/D99eL/Go/uC1nboEHA5QcppkRGqzsIEmQKpTqagUO8+NZ+7SzFa/+CYeuB+5GwMTpYFnhUl/6TscUruVkpXBSmcKKutEwyDQ/d7dz6GZGv4g4KOUKyU2RInuG8GgKsIfOa1Ru+94F6zdxm63bUpufl8C6HwKtmAg9Y9jG7YmBhraaS0f4nRVWlWIEUxIGMMxsmftv2HSHZyCwsBlbqKc8LzaKybRZB630LCxt4sit9lRxS1UPYAkkstO4b2gCaOw3S+YLvxnskYnkc+FH5tESkG1rDKetJ9CztZ83t6DCHn+X1aSwroKod9ogzfX5sXYsr66Xr/MkadHV3gGBG6ix5Fsrq

On 26/05/18 09:35PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This series applies bug fixes (mostly found via sashiko) to the dax/fsdev
> series. This has been soaking in the famfs CI pipeline for 2+ weeks and
> 1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
> doesn't affect any known workloads - although the bugs would have
> manifested when multi-range DCD dax devices are a thing (soon-ish).

Quick note: I just noticed that this series generates a conflict on 
7.1-rc4. I'll update within a day or so to clean that up.

John

