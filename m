Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7852F80
	for <nvdimm@lists.linux.dev>; Wed,  9 Jun 2021 01:27:22 +0000 (UTC)
IronPort-SDR: thE6vPrzp5TKSjpFTAzAgogG3rpb/TQi84WMF55L3b87tbYq8KlwZKc8EhSs3gRsEFuKyYP0LT
 K8Ix3Mv8j2pA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="203127561"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="203127561"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 18:27:20 -0700
IronPort-SDR: EY//goGmVT8zFoLzwM+a/wrOzL23krQqSznNl2egAWKMChD9tFfbr33OulW30VDRYep7vOQUJo
 2ZiiukjYpz/w==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="482194703"
Received: from jingqili-mobl.ccr.corp.intel.com (HELO [10.238.4.189]) ([10.238.4.189])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 18:27:19 -0700
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev
References: <20210603012556.77451-1-jingqi.liu@intel.com>
 <CAPcyv4hzS93k5PYXE_bVp6SQ8WwPw09B+SyJC0xPKE20simwuQ@mail.gmail.com>
From: "Liu, Jingqi" <jingqi.liu@intel.com>
Message-ID: <5e4349ec-18d9-ce11-c5cd-f1918404ff91@intel.com>
Date: Wed, 9 Jun 2021 09:27:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hzS93k5PYXE_bVp6SQ8WwPw09B+SyJC0xPKE20simwuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dan,

On 6/8/2021 4:03 AM, Dan Williams wrote:
> On Wed, Jun 2, 2021 at 6:36 PM Jingqi Liu <jingqi.liu@intel.com> wrote:
>>
>> The following bug is caused by setting the size of Label Index Block
>> to a fixed 256 bytes.
>>
>> Use the following Qemu command to start a Guest with 2MB label-size:
>>          -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>>          -device nvdimm,memdev=mem1,id=nv1,label-size=2M
>>
>> There is a namespace in the Guest as follows:
>>          $ ndctl list
>>          [
>>            {
>>              "dev":"namespace0.0",
>>              "mode":"devdax",
>>              "map":"dev",
>>              "size":14780727296,
>>              "uuid":"58ad5282-5a16-404f-b8ee-e28b4c784eb8",
>>              "chardev":"dax0.0",
>>              "align":2097152,
>>              "name":"namespace0.0"
>>            }
>>          ]
>>
>> Fail to read labels. The result is as follows:
>>          $ ndctl read-labels -u nmem0
>>          [
>>          ]
>>          read 0 nmem
>>
>> If using the following Qemu command to start the Guest with 128K
>> label-size, this label can be read correctly.
>>          -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>>          -device nvdimm,memdev=mem1,id=nv1,label-size=128K
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
>> When reading namespace index and labels, we should read the field of 'mysize'
>> in the Label Index Block. Then we can correctly calculate the starting offset
>> of another Label Index Block and the following namespace labels.
> 
> Good find! I agree this is broken, but I'm not sure this is the way to
> fix it. The ndctl enabling is meant to support dumping index blocks
> that might be corrupt, so I don't want to rely on index block data for
> this value. It should copy the kernel which has this definition for
> determining sizeof_namespace_index():
> 
> size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
> {
>          u32 nslot, space, size;
> 
>          /*
>           * Per UEFI 2.7, the minimum size of the Label Storage Area is large
>           * enough to hold 2 index blocks and 2 labels.  The minimum index
>           * block size is 256 bytes. The label size is 128 for namespaces
>           * prior to version 1.2 and at minimum 256 for version 1.2 and later.
>           */
>          nslot = nvdimm_num_label_slots(ndd);
>          space = ndd->nsarea.config_size - nslot * sizeof_namespace_label(ndd);
>          size = __sizeof_namespace_index(nslot) * 2;
>          if (size <= space && nslot >= 2)
>                  return size / 2;
> 
>          dev_err(ndd->dev, "label area (%d) too small to host (%d byte)
> labels\n",
>                          ndd->nsarea.config_size, sizeof_namespace_label(ndd));
>          return 0;
> }
> 
Good point. Thanks for your comment.
I'll send a patch based on your suggestion soon.

Thanks,
Jingqi
