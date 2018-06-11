Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E444F2118D92F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 10:35:58 -0700 (PDT)
Date: Mon, 11 Jun 2018 10:35:58 -0700
From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
Message-ID: <20180611173558.GB11953@tassilo.jf.intel.com>
References: <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
 <20180606073910.GB32433@dhcp22.suse.cz>
 <CAPcyv4hA2Na7wyuyLZSWG5s_4+pEv6aMApk23d2iO1vhFx92XQ@mail.gmail.com>
 <20180607143724.GS32433@dhcp22.suse.cz>
 <CAPcyv4jnyuC-yjuSgu4qKtzB0h9yYMZDsg5Rqqa=HTCY9KM_gw@mail.gmail.com>
 <20180611075004.GH13364@dhcp22.suse.cz>
 <CAPcyv4gSTMEi5XdzLQZqxMMKCcwF=me02wCiRtAAXSiy2CPGJA@mail.gmail.com>
 <20180611145636.GP13364@dhcp22.suse.cz>
 <CAPcyv4hnPRk0hTGctHB4tBnyL_27x3DwPUVwhZ+L7c-=1Xdf6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hnPRk0hTGctHB4tBnyL_27x3DwPUVwhZ+L7c-=1Xdf6Q@mail.gmail.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 08:19:54AM -0700, Dan Williams wrote:
> On Mon, Jun 11, 2018 at 7:56 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 11-06-18 07:44:39, Dan Williams wrote:
> > [...]
> >> I'm still trying to understand the next level of detail on where you
> >> think the design should go next? Is it just the HWPoison page flag?
> >> Are you concerned about supporting greater than PAGE_SIZE poison?
> >
> > I simply do not want to check for HWPoison at zillion of places and have
> > each type of page to have some special handling which can get wrong very
> > easily. I am not clear on details here, this is something for users of
> > hwpoison to define what is the reasonable scenarios when the feature is
> > useful and turn that into a feature list that can be actually turned
> > into a design document. See the different from let's put some more on
> > top approach...
> >
> 
> So you want me to pay the toll of writing a design document justifying
> all the existing use cases of HWPoison before we fix the DAX bugs, and
> the design document may or may not result in any substantive change to
> these patches?
> 
> Naoya or Andi, can you chime in here?

A new document doesn't make any sense. We have the commit messages and
the code comments as design documents, and as usual the ultimative authority is
what the code does.

The guiding light for new memory recovery code is just these sentences (taken
from the beginning of the main file):

 * In general any code for handling new cases should only be added iff:
 * - You know how to test it.
 * - You have a test that can be added to mce-test
 *   https://git.kernel.org/cgit/utils/cpu/mce/mce-test.git/
 * - The case actually shows up as a frequent (top 10) page state in
 *   tools/vm/page-types when running a real workload.

Since persistent memory is so big it makes sense to add support
for it in common code paths. That is usually just kernel copies and
user space execution.

-Andi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
