Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBB5221951C94
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 15:57:53 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id j201so189912516oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 15:57:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170425222250.GC15722@omniknight.lm.intel.com>
References: <20170425211651.7640-1-toshi.kani@hpe.com>
 <20170425214422.GB15722@omniknight.lm.intel.com>
 <1493156958.26622.8.camel@hpe.com>
 <20170425222250.GC15722@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Apr 2017 15:57:52 -0700
Message-ID: <CAPcyv4jfDuhPPFamJv5r-f7NuJpAE47xo62NKr5ZWsp86_4Nww@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix phys_addr for nvdimm_clear_poison
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 3:22 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 04/25, Kani, Toshimitsu wrote:
>> On Tue, 2017-04-25 at 15:44 -0600, Vishal Verma wrote:
>> > On 04/25, Toshi Kani wrote:
> [...]
>> >
>> > Should we be using nsio->res.start here or nsio->addr ?
>>
>> nsio->addr is a virtual address.  We need to pass the physical address
>> of this range.
>
> I see - makes sense.
> You can add
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
