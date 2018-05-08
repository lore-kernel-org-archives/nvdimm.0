Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CCD2203B8585
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 16:41:27 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id v63so24685145pfk.8
 for <linux-nvdimm@lists.01.org>; Tue, 08 May 2018 16:41:27 -0700 (PDT)
Date: Wed, 9 May 2018 08:41:23 +0900
From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link sibling resource
Message-ID: <20180508234123.GA23307@WeideMacBook-Pro.local>
References: <20180419001848.3041-1-bhe@redhat.com>
 <20180419001848.3041-2-bhe@redhat.com>
 <20180426011837.GA79340@WeideMacBook-Pro.local>
 <20180507011429.GG30581@MiWiFi-R3L-srv>
 <20180508114845.GA19459@WeideMacBook-Pro.local>
 <20180508121123.GI30581@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180508121123.GI30581@MiWiFi-R3L-srv>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Baoquan He <bhe@redhat.com>
Cc: nicolas.pitre@linaro.org, Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, josh@joshtriplett.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, robh+dt@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 08, 2018 at 08:11:23PM +0800, Baoquan He wrote:
>On 05/08/18 at 08:48pm, Wei Yang wrote:
>> On Mon, May 07, 2018 at 09:14:29AM +0800, Baoquan He wrote:
>> >Hi Wei Yang,
>> >
>> >On 04/26/18 at 09:18am, Wei Yang wrote:
>> >> On Thu, Apr 19, 2018 at 08:18:46AM +0800, Baoquan He wrote:
>> >> >The struct resource uses singly linked list to link siblings. It's not
>> >> >easy to do reverse iteration on sibling list. So replace it with list_head.
>> >> >
>> >> 
>> >> Hi, Baoquan
>> >> 
>> >> Besides changing the data structure, I have another proposal to do the reverse
>> >> iteration. Which means it would not affect other users, if you just want a
>> >> reverse iteration.
>> >> 
>> >> BTW, I don't think Andrew suggest to use linked-list directly. What he wants
>> >> is a better solution to your first proposal in
>> >> https://patchwork.kernel.org/patch/10300819/.
>> >> 
>> >> Below is my proposal of resource reverse iteration without changing current
>> >> design.
>> >
>> >I got your mail and read it, then interrupted by other thing and forgot
>> >replying, sorry.
>> >
>> >I am fine with your code change. As I said before, I have tried to change
>> >code per reviewers' comment, then let reviewers decide which way is
>> >better. Please feel free to post formal patches and joining discussion
>> >about this issue.
>> 
>> Yep, while I don't have a real requirement to add the reverse version, so what
>> is the proper way to send a patch?
>> 
>> A patch reply to this thread is ok?
>
>I am not sure either. Since my patches are still under reviewing. And
>you have pasted your patch. It depends on maintainers, mainly Andrew and
>other reviewers who have concerns.

Ok, thanks.

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
