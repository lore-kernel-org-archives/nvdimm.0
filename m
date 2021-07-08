Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D8173
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 01:53:29 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="295064699"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="295064699"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 18:53:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="498193450"
Received: from jingqili-mobl.ccr.corp.intel.com (HELO [10.238.6.254]) ([10.238.6.254])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 18:53:28 -0700
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <20210609030642.66204-1-jingqi.liu@intel.com>
 <8110e80df98fb57fd20d0bf73dc7d266fef5ab84.camel@intel.com>
From: "Liu, Jingqi" <jingqi.liu@intel.com>
Message-ID: <9cba6794-e3ea-fb89-1391-e3bd992912a6@intel.com>
Date: Thu, 8 Jul 2021 09:53:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8110e80df98fb57fd20d0bf73dc7d266fef5ab84.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vishal,

Thanks for your comments.

On 7/8/2021 8:21 AM, Verma, Vishal L wrote:
> On Wed, 2021-06-09 at 11:06 +0800, Jingqi Liu wrote:
>> The following bug is caused by setting the size of Label Index Block
>> to a fixed 256 bytes.
>>
>> Use the following Qemu command to start a Guest with 2MB label-size:
>>        -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>>        -device nvdimm,memdev=mem1,id=nv1,label-size=2M
>>
>> There is a namespace in the Guest as follows:
>>        $ ndctl list
>>        [
>>          {
>>            "dev":"namespace0.0",
>>            "mode":"devdax",
>>            "map":"dev",
>>            "size":14780727296,
>>            "uuid":"58ad5282-5a16-404f-b8ee-e28b4c784eb8",
>>            "chardev":"dax0.0",
>>            "align":2097152,
>>            "name":"namespace0.0"
>>          }
>>        ]
>>
>> Fail to read labels. The result is as follows:
>>        $ ndctl read-labels -u nmem0
>>        [
>>        ]
>>        read 0 nmem
>>
>> If using the following Qemu command to start the Guest with 128K
>> label-size, this label can be read correctly.
>>        -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>>        -device nvdimm,memdev=mem1,id=nv1,label-size=128K
>>
>> The size of a Label Index Block depends on how many label slots fit into
>> the label storage area. The minimum size of an index block is 256 bytes
>> and the size must be a multiple of 256 bytes. For a storage area of 128KB,
>> the corresponding Label Index Block size is 256 bytes. But if the label
>> storage area is not 128KB, the Label Index Block size should not be 256 bytes.
>>
>> Namespace Label Index Block appears twice at the top of the label storage area.
>> Following the two index blocks, an array for storing labels takes up the
>> remainder of the label storage area.
>>
>> For obtaining the size of Namespace Index Block, we also cannot rely on
>> the field of 'mysize' in this index block since it might be corrupted.
>> Similar to the linux kernel, we use sizeof_namespace_index() to get the size
>> of Namespace Index Block. Then we can also correctly calculate the starting
>> offset of the following namespace labels.
>>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>> ---
>>   ndctl/dimm.c           | 19 +++++++++++++++----
>>   ndctl/lib/dimm.c       |  5 +++++
>>   ndctl/lib/libndctl.sym |  1 +
>>   ndctl/libndctl.h       |  1 +
>>   4 files changed, 22 insertions(+), 4 deletions(-)
> 
> Hi Jingqi,
> 
> This looks fine, one comment below.
> 
> [..]
>>
>> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
>> index 0a82616..0ce2bb9 100644
>> --- a/ndctl/lib/libndctl.sym
>> +++ b/ndctl/lib/libndctl.sym
>> @@ -290,6 +290,7 @@ global:
>>        ndctl_dimm_validate_labels;
>>        ndctl_dimm_init_labels;
>>        ndctl_dimm_sizeof_namespace_label;
>> +     ndctl_dimm_sizeof_namespace_index;
> 
> This can't go into an 'old' section of the symbol version script - if
> you base off the current 'pending' branch, you should see a LIBNDCTL_26
> section at the bottom. You can add this there.

It's based on the current 'master' branch.
I don't see a LIBNDCTL_26 section, just 'LIBNDCTL_25'.
How about adding 'ndctl_dimm_sizeof_namespace_index' to LIBNDCTL_25 
section ?

Thanks,
Jingqi
