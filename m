Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDCB52122B976
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 01:55:45 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4J8pL6c121013
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 04:55:44 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sjy9jgynq-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 04:55:44 -0400
Received: from localhost
 by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Sun, 19 May 2019 09:55:42 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] mm/nvdimm: Pick the right alignment default when creating
 dax devices
In-Reply-To: <de5cbe7d-bd47-6793-1f1a-2274c5c59eb5@linux.ibm.com>
References: <20190514025449.9416-1-aneesh.kumar@linux.ibm.com>
 <875zq9m8zx.fsf@vajain21.in.ibm.com>
 <de5cbe7d-bd47-6793-1f1a-2274c5c59eb5@linux.ibm.com>
Date: Sun, 19 May 2019 14:25:33 +0530
MIME-Version: 1.0
Message-Id: <87sgtaddru.fsf@linux.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-mm@kvack.org, Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi Dan,

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On 5/17/19 8:19 PM, Vaibhav Jain wrote:
>> Hi Aneesh,
>> 

....

>>
>>> +	/*
>>> +	 * Check whether the we support the alignment. For Dax if the
>>> +	 * superblock alignment is not matching, we won't initialize
>>> +	 * the device.
>>> +	 */
>>> +	if (!nd_supported_alignment(align) &&
>>> +	    memcmp(pfn_sb->signature, DAX_SIG, PFN_SIG_LEN)) {
>> Suggestion to change this check to:
>> 
>> if (memcmp(pfn_sb->signature, DAX_SIG, PFN_SIG_LEN) &&
>>     !nd_supported_alignment(align))
>> 
>> It would look  a bit more natural i.e. "If the device has dax signature and alignment is
>> not supported".
>> 
>
> I guess that should be !memcmp()? . I will send an updated patch with 
> the hash failure details in the commit message.
>

We need clarification on what the expected failure behaviour should be.
The nd_pmem_probe doesn't really have a failure behaviour in this
regard. For example.

I created a dax device with 16M alignment

{                                          
  "dev":"namespace0.0",
  "mode":"devdax",                         
  "map":"dev",                             
  "size":"9.98 GiB (10.72 GB)",
  "uuid":"ba62ef22-ebdf-4779-96f5-e6135383ed22",
  "raw_uuid":"7b2492f9-7160-4ee9-9c3d-2f547d9ef3ee",
  "daxregion":{                            
    "id":0,                                
    "size":"9.98 GiB (10.72 GB)",
    "align":16777216,
    "devices":[                            
      {                                    
        "chardev":"dax0.0",
        "size":"9.98 GiB (10.72 GB)"
      }                                    
    ]                                      
  },                                       
  "align":16777216,                        
  "numa_node":0,                           
  "supported_alignments":[
    65536,                                 
    16777216                               
  ]                                        
}      

Now what we want is to fail the initialization of the device when we
boot a kernel that doesn't support 16M page size. But with the
nd_pmem_probe failure behaviour we now end up with

[
  {
    "dev":"namespace0.0",
    "mode":"fsdax",
    "map":"mem",
    "size":10737418240,
    "uuid":"7b2492f9-7160-4ee9-9c3d-2f547d9ef3ee",
    "blockdev":"pmem0"
  }
]

So it did fallthrough the

	/* if we find a valid info-block we'll come back as that personality */
	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
			|| nd_dax_probe(dev, ndns) == 0)
		return -ENXIO;

	/* ...otherwise we're just a raw pmem device */
	return pmem_attach_disk(dev, ndns);


Is it ok if i update the code such that we don't do that default
pmem_atach_disk if we have a label area?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
