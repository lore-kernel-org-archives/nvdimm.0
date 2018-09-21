Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEBBD211546FA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 12:29:05 -0700 (PDT)
Subject: Re: [PATCH V5 4/4] kvm: add a check if pfn is from NVDIMM pmem.
References: <cover.1536342881.git.yi.z.zhang@linux.intel.com>
 <4e8c2e0facd46cfaf4ab79e19c9115958ab6f218.1536342881.git.yi.z.zhang@linux.intel.com>
 <CAPcyv4ifg2BZMTNfu6mg0xxtPWs3BVgkfEj51v1CQ6jp2S70fw@mail.gmail.com>
 <fefbd66e-623d-b6a5-7202-5309dd4f5b32@redhat.com>
 <20180920224953.GA53363@tiger-server>
 <CAPcyv4g6OS=_uSjJenn5WVmpx7zCRCbzJaBr_m0Bq=qyEyVagg@mail.gmail.com>
 <20180921224739.GA33892@tiger-server>
 <c8ad8ed7-ca8c-4dd7-819b-8d9c856fbe04@redhat.com>
 <CAPcyv4j9K-wkq8oK-8_twWViKhyGSHD7cOE5UoRN-09xKXPq7A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <159bb198-a4a1-0fee-bf57-24c3c28788bd@redhat.com>
Date: Fri, 21 Sep 2018 21:29:00 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j9K-wkq8oK-8_twWViKhyGSHD7cOE5UoRN-09xKXPq7A@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, rkrcmar@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On 21/09/2018 20:17, Dan Williams wrote:
> On Fri, Sep 21, 2018 at 7:24 AM David Hildenbrand <david@redhat.com> wrote:
> [..]
>>> Remove the PageReserved flag sounds more reasonable.
>>> And Could we still have a flag to identify it is a device private memory, or
>>> where these pages coming from?
>>
>> We could use a page type for that or what you proposed. (as I said, we
>> might have to change hibernation code to skip the pages once we drop the
>> reserved flag).
> 
> I think it would be reasonable to reject all ZONE_DEVICE pages in
> saveable_page().
> 

Indeed, that sounds like the easiest solution - guess that answer was
too easy for me to figure out :) .

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
