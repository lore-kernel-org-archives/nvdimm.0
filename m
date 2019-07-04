Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com
 [IPv6:2a00:1450:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3074212B0809
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jul 2019 07:32:27 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i11so5628844edq.0
 for <linux-nvdimm@lists.01.org>; Thu, 04 Jul 2019 07:32:27 -0700 (PDT)
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <f23a1c71-d1b1-b279-c922-ce0f48cb4448@gmail.com>
 <20190704135804.GL1729@bombadil.infradead.org>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <bfe7c33d-7c3c-dcc0-5408-e23ea8223ef0@gmail.com>
Date: Thu, 4 Jul 2019 17:32:23 +0300
MIME-Version: 1.0
In-Reply-To: <20190704135804.GL1729@bombadil.infradead.org>
Content-Language: en-MW
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seema Pandit <seema.pandit@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 04/07/2019 16:58, Matthew Wilcox wrote:
> On Thu, Jul 04, 2019 at 04:00:00PM +0300, Boaz Harrosh wrote:
<>
>> Matthew you must be kidding an ilog2 in binary is zero clocks
>> (Return the highest bit or something like that)
> 
> You might want to actually check the documentation instead of just
> making shit up.
> 

Yes you are right I stand corrected. Must be smoking ;-)

> https://www.agner.org/optimize/instruction_tables.pdf
> 
> I think in this instance what we want is BSR (aka ffz) since the input is
> going to be one of 0, 1, 3, 7, 15 or 31 (and we want 0, 1, 2, 3, 4, 5 as
> results).
> 
<>
> The compiler doesn't know the range of 'sibs'.  Unless we do the
> profile-feedback thing.
> 

Would you please consider the use of get_order() macro from #include <getorder.h>
Just for the sake of understanding? (Or at least a comment)

Thanks
Boaz
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
