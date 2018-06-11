Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DE292114A6D3
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 07:56:39 -0700 (PDT)
Date: Mon, 11 Jun 2018 16:56:36 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
Message-ID: <20180611145636.GP13364@dhcp22.suse.cz>
References: <20180604124031.GP19202@dhcp22.suse.cz>
 <CAPcyv4gLxz7Ke6ApXoATDN31PSGwTgNRLTX-u1dtT3d+6jmzjw@mail.gmail.com>
 <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
 <20180606073910.GB32433@dhcp22.suse.cz>
 <CAPcyv4hA2Na7wyuyLZSWG5s_4+pEv6aMApk23d2iO1vhFx92XQ@mail.gmail.com>
 <20180607143724.GS32433@dhcp22.suse.cz>
 <CAPcyv4jnyuC-yjuSgu4qKtzB0h9yYMZDsg5Rqqa=HTCY9KM_gw@mail.gmail.com>
 <20180611075004.GH13364@dhcp22.suse.cz>
 <CAPcyv4gSTMEi5XdzLQZqxMMKCcwF=me02wCiRtAAXSiy2CPGJA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gSTMEi5XdzLQZqxMMKCcwF=me02wCiRtAAXSiy2CPGJA@mail.gmail.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 11-06-18 07:44:39, Dan Williams wrote:
[...]
> I'm still trying to understand the next level of detail on where you
> think the design should go next? Is it just the HWPoison page flag?
> Are you concerned about supporting greater than PAGE_SIZE poison?

I simply do not want to check for HWPoison at zillion of places and have
each type of page to have some special handling which can get wrong very
easily. I am not clear on details here, this is something for users of
hwpoison to define what is the reasonable scenarios when the feature is
useful and turn that into a feature list that can be actually turned
into a design document. See the different from let's put some more on
top approach...

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
