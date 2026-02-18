Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3B2F49EB
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771457622; cv=none; b=r1H4xOLq/E2hUD5pvmKTbQUyj1/fof8JY7cFus0e7gOcpw2qyGJOTxVuUMdxLI7Bw4BbDzWUMNE/zAaCkjga4nxtZ4BxtkOCHfYDIO2LGCJzmVXdMQTfLhDPBUUzR/qtbr6z8mWyL04Ui7tzzyioX0GSo5iZH9bXODxl1D0Duxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771457622; c=relaxed/simple;
	bh=D5BbzAcUzisA/eO9fnBpFALrBThvwHCcKR72kn6oMtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxiV2ddFLtLhZeNFV5WZmCke8YDkbQM1ruopHiWPQqfEfblB0lanXRap6ZDGLr87hu9B5mSiulOWYoBJ71PBnfAq70MGW1sdIeYAeIhNeprjthBMb9Aqww2IOn7f3HouIN3oiISn2wGXYaFOmVfjfwjY3i81lpgE577Ily0syfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNphvBe6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNphvBe6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771457621; x=1802993621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D5BbzAcUzisA/eO9fnBpFALrBThvwHCcKR72kn6oMtU=;
  b=GNphvBe6TLvClFZiOF1iLAcZIPIkMpXCL1n/fLl9mwpFmjgvZ/bk+bym
   VtH6ybu1E6B3dxOGWeobX/oxnFVRXSceQDaJNWGGveCUy9KGcxTC6oXGR
   3pdR415hXLybug/J1eR0jwNZ/2VYSQ0Gq6xKDY1ihTFzOJWBbgOxk1NIp
   qGcmXyb0udU5Rc2vi84SziL/h3UZE8ioJocGe3hJ3bh/eyE3hjwI8W7mk
   II8jJ1jgBasfUU44QZcCJr2B0D63toQNbTtZe3E8rmq0iyrfNK1p0ug5E
   HfaW9/jOE6cAviKtZiLRudw9CkK+bRH0ZrpNuIWjpYbrKfxIwxY1t6S5F
   w==;
X-CSE-ConnectionGUID: IoTi28ytRZGeKU3tHcWHBg==
X-CSE-MsgGUID: Q+xluJryTneYZLSqu+hRpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="98004802"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="98004802"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 15:33:40 -0800
X-CSE-ConnectionGUID: HkCANN//T+2NNQk2+gCxtw==
X-CSE-MsgGUID: cEuOHjX9Qom/uXF1mOq38g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="214352687"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.212]) ([10.125.109.212])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 15:33:37 -0800
Message-ID: <89c2f617-23c7-4767-8712-cfe32260bfdf@intel.com>
Date: Wed, 18 Feb 2026 16:33:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 04/19] dax: Save the kva from memremap
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
 <20260118223138.92368-1-john@jagalactic.com>
 <0100019bd33c54b5-81c8e4b0-2692-47bb-b555-2657a7f297ba-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019bd33c54b5-81c8e4b0-2692-47bb-b555-2657a7f297ba-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/18/26 3:31 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> Save the kva from memremap because we need it for iomap rw support.
> 
> Prior to famfs, there were no iomap users of /dev/dax - so the virtual
> address from memremap was not needed.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/dax-private.h | 2 ++
>  drivers/dax/fsdev.c       | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 0867115aeef2..4ae4d829d3ee 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -69,6 +69,7 @@ struct dev_dax_range {
>   * data while the device is activated in the driver.
>   * @region - parent region
>   * @dax_dev - core dax functionality
> + * @virt_addr: kva from memremap; used by fsdev_dax
>   * @target_node: effective numa node if dev_dax memory range is onlined
>   * @dyn_id: is this a dynamic or statically created instance
>   * @id: ida allocated id when the dax_region is not static
> @@ -81,6 +82,7 @@ struct dev_dax_range {
>  struct dev_dax {
>  	struct dax_region *region;
>  	struct dax_device *dax_dev;
> +	void *virt_addr;
>  	unsigned int align;
>  	int target_node;
>  	bool dyn_id;
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 29b7345f65b1..72f78f606e06 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -201,6 +201,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
>  		       __func__, phys, pgmap_phys, data_offset);
>  	}
> +	dev_dax->virt_addr = addr + data_offset;
>  
>  	inode = dax_inode(dax_dev);
>  	cdev = inode->i_cdev;

