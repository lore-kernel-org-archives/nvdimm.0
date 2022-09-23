Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1733FED
	for <nvdimm@lists.linux.dev>; Fri, 23 Sep 2022 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663949885; x=1695485885;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2j6YOJbRNidSzoxVdfG5XPyqHuoIKbKoyF3mn4CCIAg=;
  b=UrPWxx1kGODWDxxRCgtjrHq+i1GPyJjiuJDqk/9hT6sx41MgIzplqUCr
   ySCf89RYXLKJ6LyeH6YYLhS8qy/ZuJu2a2idOMeW+FQ/f97CJnPR02CUK
   UtIBgHMpooDmZoSR4llxT2YibOCzbiP1zWiduSJywOig6AZAbAfpKFXPl
   4p6eM1qNDD7Vu9XO3pA6crJmCRkD2PX69GDThmagRq+q0BFfd7oaXcsHz
   xkKi0/s5UnBlTWoBsV6oc5gt8J7Zrf+8mVO4N184bVGYN36Cp5m7HoA+r
   DFBluGNADuvbTZ9WyW829Qk0g1lpRFhNQMeW0tN6NYNLXuR39ccxMLXs3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="326956571"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="326956571"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 09:18:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="682708390"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.52.203]) ([10.212.52.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 09:18:04 -0700
Message-ID: <ef36340d-6bd3-34f4-c728-d7f434f672c1@intel.com>
Date: Fri, 23 Sep 2022 09:18:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH v2 19/19] cxl: add dimm_id support for __nvdimm_create()
Content-Language: en-US
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com,
 Jonathan.Cameron@huawei.com
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377440119.430546.15623409728442106946.stgit@djiang5-desk3.ch.intel.com>
 <20220923103108.wt62gzebnyovpjjr@offworld>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220923103108.wt62gzebnyovpjjr@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/23/2022 3:31 AM, Davidlohr Bueso wrote:
> On Wed, 21 Sep 2022, Dave Jiang wrote:
>
>> Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
>> security code uses that as the key description for the security key 
>> of the
>> memory device. The nvdimm unlock code cannot find the respective key
>> without the dimm_id.
>
> Maybe I'm being daft but I don't see why cxlds->serial could not just be
> used for __nvdimm_create() instead of adding a new member.
>
The reason is cxlds->serial is a u64 and __nvdimm_create() wants a 
string for dimm_id. And also __nvdimm_create() just points to the 
original string instead of duplicating it. So we need a string member 
defined instead of creating a temp string derived from cxlds->serial for 
__nvdimm_create().
