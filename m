Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0A244685
	for <nvdimm@lists.linux.dev>; Thu, 19 Feb 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771517925; cv=none; b=J/5pkQBkRQ9cHtou2mOTjOlPJ520mFf+U7kcrWGVYUfm0d1k8WJDQfI8vfem96e6xqlxiD7GKGL6y8GfUOvnuGiuXgSKko3pme2dE1EXCTro7B747EV08FkdMFbZ55Al/bUI8i8bocQUf6OILRoXg9L2rydQcg5hpRoB2QqpZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771517925; c=relaxed/simple;
	bh=DC5amSNOmM7Ixn9On9eMnJ09Y9fdeTbTT8IaO12xmrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nMbMWNNxbADuwtxWSnFhEb+iA0pasdM8eTZuzs0iauH6ysaD/xsc+Ab4sC5bYwgEt0z4qEtWzL58PKdsO/P0xu+qKY3+L6q65eCjgNNU5F5gWllyH6Vnm7CHiX+I6l5aempAK1Fc5gVmm9pX41UxQX/E39ejLP9T7bRJDABf5hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V2kqW8xL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V2kqW8xL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771517924; x=1803053924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DC5amSNOmM7Ixn9On9eMnJ09Y9fdeTbTT8IaO12xmrs=;
  b=V2kqW8xLgele4v3FUI6iW9dmIpcaZwObq/WrfsIrlXaDCoGgFKGOYXNH
   T3pZAwoiSvjj/F68jmRhuWZt3gQQKDTf1k27DmJRKmOrV3JaYs4MTXuPJ
   ZUtEDQySpA4ue9Sn+MI4EoDoW1fASlI1wia6tuYwN2J2or6QJK29L/ZkU
   g0NtYSGtsozX3jx1+J/VgVNlRadjv5KcXzWkshIuekk884jbkiOScotAC
   JzAQZLlyit3Os8QasDvhUo5KEPoCSCtqzKzdByY9xOhkYLDRxM4TMaLtp
   0rp59vIIT80mi1ifH7y1/P6Rz6Es7e31i7krFhDkabD+3ND7cEP3x8NSb
   w==;
X-CSE-ConnectionGUID: Aw8XBImESwO8unwwAWe1rQ==
X-CSE-MsgGUID: GXgyAs18SaCg7GuUNRvkuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="98070478"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="98070478"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 08:18:43 -0800
X-CSE-ConnectionGUID: orUrHXxSTXiQQ4p5uFAFPw==
X-CSE-MsgGUID: zxSaD6lbSE6QJlO3eDgUMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="219098453"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 08:18:40 -0800
Message-ID: <6f1b7b96-e732-43ca-88d0-b4cdf0203ccf@intel.com>
Date: Thu, 19 Feb 2026 09:18:38 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 08/19] dax: export dax_dev_get()
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223215.92448-1-john@jagalactic.com>
 <0100019bd33ce5b3-da53cf2e-141d-4bc2-94a8-aa5487eadfb5-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019bd33ce5b3-da53cf2e-141d-4bc2-94a8-aa5487eadfb5-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/18/26 3:32 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> famfs needs to look up a dax_device by dev_t when resolving fmap
> entries that reference character dax devices.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

It's tiny enough that maybe you can just squash it with the commit that you are using it?

> ---
>  drivers/dax/super.c | 3 ++-
>  include/linux/dax.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 00c330ef437c..d097561d78db 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -513,7 +513,7 @@ static int dax_set(struct inode *inode, void *data)
>  	return 0;
>  }
>  
> -static struct dax_device *dax_dev_get(dev_t devt)
> +struct dax_device *dax_dev_get(dev_t devt)
>  {
>  	struct dax_device *dax_dev;
>  	struct inode *inode;
> @@ -536,6 +536,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
>  
>  	return dax_dev;
>  }
> +EXPORT_SYMBOL_GPL(dax_dev_get);
>  
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 6897c5736543..1ef9b03f9671 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -55,6 +55,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
> +struct dax_device *dax_dev_get(dev_t devt);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);

