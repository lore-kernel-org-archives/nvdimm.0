Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C997F1E0DD9;
	Fri, 13 Dec 2024 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100437; cv=none; b=ocbjXczkHG9dwN5wZ4ILrC0icLaoetEkM367+mPD5XLRXxAVWoBltO7JeWSwGzTIaTvf43WyZp2sINSmjYg6YzsC7ooGvYajeD5dNUio+LvzmIDgUYRC84GPMJVv5BOHouMwGC2hrV4pkv+41fplPTejIQh5FEdeQj7/zedMckQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100437; c=relaxed/simple;
	bh=f9c9IFBC1K3O3m/EYe+GtyRkm0WHPIplnL+SfvMSmLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9o1ek1MRiLtCbe/R4VzSFb1YitOUyNT9UNVoKti9ND8lBIEKIodiHOpRdcQr+nQwujsMEQop/+ZpMhiCkgyy7EwrUqjyt6ZebMdhZkQ6kjH5d3I3+z1VtH6JB/D5DHWVbjNt2/hjz5fKQLsOCcXrcgxhkz6nSCDKIpUktsGoB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19E5C68AA6; Fri, 13 Dec 2024 15:33:52 +0100 (CET)
Date: Fri, 13 Dec 2024 15:33:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: M Nikhil <nikh1092@linux.ibm.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de,
	steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
Message-ID: <20241213143351.GB16111@lst.de>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi M,

On Fri, Dec 13, 2024 at 12:46:14PM +0530, M Nikhil wrote:
> Hi Everyone,
>
>  * We have observed change in the values of some of the block integrity
>    sysfs attributes for the block devices on the master branch. The
>    sysfs attributes related to block device integrity , write_generate
>    and read_verify are  enabled for the block device when the parameter
>    device_is_integrity_capable is disabled. This behaviour is seen on
>    the scsi disks irrespective of DIF protection enabled or disabled on
>    the disks.

As in after a "echo 1 > /sys/.../device_is_integrity_capable" ?

I'll look into it.

