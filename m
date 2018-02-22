Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53803222630AB
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 13:41:18 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id w38so6009847ota.8
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 13:47:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180222211224.GA29462@linux.intel.com>
References: <151275056532.8020.17160155121603376532.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171218195405.GA18900@linux.intel.com>
 <20180222211224.GA29462@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 22 Feb 2018 22:47:17 +0100
Message-ID: <CAJZ5v0j8kLSW2-==KjeXg5UTCzUGxn72iyS9Sj823bpLZOzNWw@mail.gmail.com>
Subject: Re: [PATCH] acpi: add NFIT and HMAT to the initrd override list
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Rafael Wysocki <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 22, 2018 at 10:12 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Mon, Dec 18, 2017 at 12:54:05PM -0700, Ross Zwisler wrote:
>> On Fri, Dec 08, 2017 at 08:29:25AM -0800, Dan Williams wrote:
>> > These tables, NFIT and HMAT, are essential for describing
>> > next-generation platform memory topologies and performance
>> > characteristics. Allow them to be overridden for debug and test and
>> > purposes.
>> >
>> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> Yes please!  This works in my test setup for inserting custom HMAT tables, and
>> I would really like to have this for testing my HMAT series:
>>
>> https://lists.01.org/pipermail/linux-nvdimm/2017-December/013571.html
>>
>> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Ping on this patch - can we get this merged?

Sure, I thought that Dan would pick it up.  Queued up now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
