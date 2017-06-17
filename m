Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E505021A143F1
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 17:45:40 -0700 (PDT)
Received: by mail-ot0-x22c.google.com with SMTP id s7so40315693otb.3
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 17:46:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CS1PR84MB0104A87F4AAB23AADF88656282C60@CS1PR84MB0104.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170612222511.22030-1-toshi.kani@hpe.com>
 <CAPcyv4i03dU37tgqyRaMugGTqjagWeZ+WAtc7deJyZkkAbO9mA@mail.gmail.com>
 <CS1PR84MB0104A87F4AAB23AADF88656282C60@CS1PR84MB0104.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Jun 2017 17:46:58 -0700
Message-ID: <CAPcyv4geo4mhj9Ly9ro+uAS0kLNbeGgv+2eUQr1cZbJfhPKQMw@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, pmem: Add sysfs notifications to badblocks
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 5:35 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Mon, Jun 12, 2017 at 3:25 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>> > Sysfs "badblocks" information may be updated during run-time that:
>> >  - MCE, SCI, and sysfs "scrub" may add new bad blocks
>> >  - Writes and ioctl() may clear bad blocks
>> >
>> > Add support to send sysfs notifications to sysfs "badblocks" file
>> > under region and pmem directories when their badblocks information
>> > is re-evaluated (but is not necessarily changed) during run-time.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Vishal Verma <vishal.l.verma@intel.com>
>> > Cc: Linda Knippers <linda.knippers@hpe.com>
>> > ---
>> > v2: Send notifications for the clearing case
>> > ---
>>
>> This looks good to me, I've applied it, but I also want to extend the
>> ndctl unit tests to cover this mechanism.
>
> Right.  For the time being, would you mind to use the attached test
> program for your sanity tests?  It simply monitors sysfs notifications
> and prints badblocks info...  Sorry for inconvenience.
>
> Since I am not familiar with the ndctl unit tests and I am traveling for
> the rest of the month, I may have to look into it after I am back.
>

No worries, I'll take a look at integrating this. Have a nice trip!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
