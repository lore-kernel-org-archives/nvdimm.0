Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 361E82194D3AE
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 15:36:17 -0700 (PDT)
Date: Wed, 26 Sep 2018 15:36:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 2/4] mm: Provide kernel parameter to allow disabling
 page init poisoning
Message-Id: <20180926153615.90661e27d0713a02651b2282@linux-foundation.org>
In-Reply-To: <f5648747-642f-763e-80b9-24fb203c85e9@intel.com>
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925201921.3576.84239.stgit@localhost.localdomain>
 <20180926073831.GC6278@dhcp22.suse.cz>
 <f5648747-642f-763e-80b9-24fb203c85e9@intel.com>
Mime-Version: 1.0
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: mingo@kernel.org, pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, Alexander Duyck <alexander.h.duyck@linux.intel.com>, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 26 Sep 2018 08:36:47 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 09/26/2018 12:38 AM, Michal Hocko wrote:
> > Why cannot you simply go with [no]vm_page_poison[=on/off]?
> 
> I was trying to look to the future a bit, if we end up with five or six
> more other options we want to allow folks to enable/disable.  I don't
> want to end up in a situation where we have a bunch of different knobs
> to turn all this stuff off at runtime.
> 
> I'd really like to have one stop shopping so that folks who have a
> system that's behaving well and don't need any debugging can get some of
> their performance back.
> 
> But, the *primary* thing we want here is a nice, quick way to turn as
> much debugging off as we can.  A nice-to-have is a future-proof,
> slub-style option that will centralize things.

Yup.  DEBUG_VM just covers too much stuff nowadays.  A general way to
make these thing more fine-grained and without requiring a rebuild
would be great.

And I expect that quite a few of the debug features could be
enabled/disabled after bootup as well, so a /proc knob is probably in
our future.  Any infrastructure which is added to support a new
kernel-command-line option should be designed with that in mind.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
