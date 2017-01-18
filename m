Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05F4981E10
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 22:01:31 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id m124so1808418oif.1
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 22:01:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170118052533.GA18349@bombadil.infradead.org>
References: <20170114002008.GA25379@linux.intel.com>
 <20170118052533.GA18349@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Jan 2017 22:01:30 -0800
Message-ID: <CAPcyv4jNz=1QdPPtM2A=3avGtVvZG=2d9JC-JD_F6u+-CYQN4g@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
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
To: willy@bombadil.infradead.org
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 17, 2017 at 9:25 PM,  <willy@bombadil.infradead.org> wrote:
> On Fri, Jan 13, 2017 at 05:20:08PM -0700, Ross Zwisler wrote:
>> We still have a lot of work to do, though, and I'd like to propose a discussion
>> around what features people would like to see enabled in the coming year as
>> well as what what use cases their customers have that we might not be aware of.
>
> +1 to the discussion
>
>> - Jan suggested [2] that we could use the radix tree as a cache to service DAX
>>   faults without needing to call into the filesystem.  Are there any issues
>>   with this approach, and should we move forward with it as an optimization?
>
> Ahem.  I believe I proposed this at last year's LSFMM.  And I sent
> patches to start that work.  And Dan blocked it.  So I'm not terribly
> amused to see somebody else given credit for the idea.
>

I "blocked" moving the phys to virt translation out of the driver
since that mapping lifetime is device specific.

However, I think caching the file offset to physical sector/address
result is a great idea.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
