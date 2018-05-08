Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05B70207E36DF
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 05:11:29 -0700 (PDT)
Date: Tue, 8 May 2018 20:11:23 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link sibling resource
Message-ID: <20180508121123.GI30581@MiWiFi-R3L-srv>
References: <20180419001848.3041-1-bhe@redhat.com>
 <20180419001848.3041-2-bhe@redhat.com>
 <20180426011837.GA79340@WeideMacBook-Pro.local>
 <20180507011429.GG30581@MiWiFi-R3L-srv>
 <20180508114845.GA19459@WeideMacBook-Pro.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180508114845.GA19459@WeideMacBook-Pro.local>
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
To: Wei Yang <richard.weiyang@gmail.com>
Cc: nicolas.pitre@linaro.org, Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, josh@joshtriplett.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, robh+dt@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/18 at 08:48pm, Wei Yang wrote:
> On Mon, May 07, 2018 at 09:14:29AM +0800, Baoquan He wrote:
> >Hi Wei Yang,
> >
> >On 04/26/18 at 09:18am, Wei Yang wrote:
> >> On Thu, Apr 19, 2018 at 08:18:46AM +0800, Baoquan He wrote:
> >> >The struct resource uses singly linked list to link siblings. It's not
> >> >easy to do reverse iteration on sibling list. So replace it with list_head.
> >> >
> >> 
> >> Hi, Baoquan
> >> 
> >> Besides changing the data structure, I have another proposal to do the reverse
> >> iteration. Which means it would not affect other users, if you just want a
> >> reverse iteration.
> >> 
> >> BTW, I don't think Andrew suggest to use linked-list directly. What he wants
> >> is a better solution to your first proposal in
> >> https://patchwork.kernel.org/patch/10300819/.
> >> 
> >> Below is my proposal of resource reverse iteration without changing current
> >> design.
> >
> >I got your mail and read it, then interrupted by other thing and forgot
> >replying, sorry.
> >
> >I am fine with your code change. As I said before, I have tried to change
> >code per reviewers' comment, then let reviewers decide which way is
> >better. Please feel free to post formal patches and joining discussion
> >about this issue.
> 
> Yep, while I don't have a real requirement to add the reverse version, so what
> is the proper way to send a patch?
> 
> A patch reply to this thread is ok?

I am not sure either. Since my patches are still under reviewing. And
you have pasted your patch. It depends on maintainers, mainly Andrew and
other reviewers who have concerns.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
