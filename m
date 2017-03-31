Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50F0F21A04839
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 06:19:34 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] apci, nfit: DSM improvements
References: <cover.1488921944.git.linda.knippers@hpe.com>
 <20170331090135.GB3848@linux-x5ow.site>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58DE5755.1090900@hpe.com>
Date: Fri, 31 Mar 2017 09:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <20170331090135.GB3848@linux-x5ow.site>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/31/2017 05:01 AM, Johannes Thumshirn wrote:
> On Tue, Mar 07, 2017 at 04:35:11PM -0500, Linda Knippers wrote:
>> The first two patches in this series are motivated by feedback
>> from distribution developers, test engineers, and management tool
>> developers.  We need the ability to test and support Linux and
>> management tools on systems that support more than one DSM family
>> for NVDIMM-N.
>>
>> We also need the ability to test and support new functions without
>> requiring users to update their kernel.  These changes will also
>> facilate development as we move toward DSM standardization.
>> The ability to restrict DSM functions to the currently documented
>> set is still in place.
>>
>> The third patch cleans up a cosmetic/modinfo parsing issue with one
>> of the existing module parameters.
> 
> Hi Linda and Dan,
> 
> Can you tell me the status of this series? I haven't seen it in Dan's
> tree and can't remember a reason why it's not merged.

I assume/hope it's just waiting for the next merge window.
At this point I think Dan is just pulling in critical fixes.
If there's some other reason, I'd like to hear about it too.

-- ljk
> 
> Thanks,
> 	Johannes
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
