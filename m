Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5862217CA
	for <nvdimm@lists.linux.dev>; Tue,  3 May 2022 03:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651549395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IAD018WElU9xghuzkSMUkUxt4Nb5z2Ox0B3F5e4aA7E=;
	b=NVejG30WRZTvx73wBgPwhZWLBc2WvWEr9eP0QOPUqVtio+rT8MnUWKJMjAYEfNx9RXWVgL
	2/eIkQbqS2SSG2Igijyb61RGpnc1kYrkaMhw4lD8dgyNG5Un4SDYG/DEMklrJNset9XwXB
	ENUDPvRkrvMgocrk7BBfVldn0SW1eDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-s-WaF6ekN36Uy0s98R70xQ-1; Mon, 02 May 2022 23:43:11 -0400
X-MC-Unique: s-WaF6ekN36Uy0s98R70xQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 048C885A5BE;
	Tue,  3 May 2022 03:43:11 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B6D51534B29;
	Tue,  3 May 2022 03:43:08 +0000 (UTC)
Date: Tue, 3 May 2022 05:43:06 +0200
From: Eugene Syromiatnikov <esyr@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, robert.hu@linux.intel.com,
	vishal.l.verma@intel.com, hch@lst.de, linux-acpi@vger.kernel.org,
	ldv@strace.io
Subject: Re: [PATCH 6/6] nvdimm/region: Delete nd_blk_region infrastructure
Message-ID: <20220503034306.GA30980@asgard.redhat.com>
References: <164688415599.2879318.17035042246954533659.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164688418803.2879318.1302315202397235855.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164688418803.2879318.1302315202397235855.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7

On Wed, Mar 09, 2022 at 07:49:48PM -0800, Dan Williams wrote:
> Now that the nd_namespace_blk infrastructure is removed, delete all the
> region machinery to coordinate provisioning aliased capacity between
> PMEM and BLK.

> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -189,7 +189,6 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
>  #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */
>  #define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
>  #define ND_DEVICE_NAMESPACE_PMEM 5  /* PMEM namespace (may alias with BLK) */
> -#define ND_DEVICE_NAMESPACE_BLK 6   /* BLK namespace (may alias with PMEM) */

As [1] suggests, this would break compilation of at least one Debian
package, as well as unknown number of any other potential users of this part
of UAPI.

>  #define ND_DEVICE_DAX_PMEM 7        /* Device DAX interface to pmem */
>  
>  enum nd_driver_flags {
> @@ -198,7 +197,6 @@ enum nd_driver_flags {
>  	ND_DRIVER_REGION_BLK      = 1 << ND_DEVICE_REGION_BLK,
>  	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
>  	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
> -	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,

The same probably applies here.

[1] https://sources.debian.org/src/ipmctl/03.00.00.0429-1/src/os/linux/lnx_system.c/?hl=334#L334

