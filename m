Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24F491A1F63
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 09:18:57 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id r187so83952111oih.3
 for <linux-nvdimm@lists.01.org>; Mon, 07 Mar 2016 09:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457373413.15454.334.camel@hpe.com>
References: <20160303215304.1014.69931.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160303215315.1014.95661.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1457146138.15454.277.camel@hpe.com>
 <CAA9_cmc9vjChKqs7P1NG9r66TGapw0cYHfcajWh_O+hk433MTg@mail.gmail.com>
 <1457373413.15454.334.camel@hpe.com>
Date: Mon, 7 Mar 2016 09:18:42 -0800
Message-ID: <CAPcyv4i2vtdz8BGGBWR2eGXhW8nuA9w+gvGJN5P__Ks_PyyRRg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] libnvdimm, pmem: adjust for section collisions
 with 'System RAM'
From: Dan Williams <dan.j.williams@intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-mm <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 7, 2016 at 9:56 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Fri, 2016-03-04 at 18:23 -0800, Dan Williams wrote:
>> On Fri, Mar 4, 2016 at 6:48 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
[..]
>> As far as I can see
>> all we do is ask firmware implementations to respect Linux section
>> boundaries and otherwise not change alignments.
>
> In addition to the requirement that pmem range alignment may not change,
> the code also requires a regular memory range does not change to intersect
> with a pmem section later.  This seems fragile to me since guest config may
> vary / change as I mentioned above.
>
> So, shouldn't the driver fails to attach when the range is not aligned by
> the section size?  Since we need to place a requirement to firmware anyway,
> we can simply state that it must be aligned by 128MiB (at least) on x86.
>  Then, memory and pmem physical layouts can be changed as long as this
> requirement is met.

We can state that it must be aligned, but without a hard specification
I don't see how we can guarantee it.  We will fail the driver load
with a warning if our alignment fixups end up getting invalidated by a
later configuration change, but in the meantime we cover the gap of a
BIOS that has generated a problematic configuration.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
