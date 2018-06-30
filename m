Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB498203369F7
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 17:42:05 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id r16-v6so9486770oie.3
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 17:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180630002904.GA13491@linux.intel.com>
References: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
 <20180629233927.6232-2-ross.zwisler@linux.intel.com>
 <CAPcyv4h+gtn-r6cVJS9wp+kbu9WGzWNFBBKQ0WjGpD7nJoo-cA@mail.gmail.com>
 <20180630002904.GA13491@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jun 2018 17:42:04 -0700
Message-ID: <CAPcyv4i=S6ULE6v_O03iwgi2wbsy8N1uFuPTMJqL3QtG7g045Q@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/3] ndctl/list.c: simplify flags handling
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 29, 2018 at 5:29 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Jun 29, 2018 at 04:57:29PM -0700, Dan Williams wrote:
>> On Fri, Jun 29, 2018 at 4:39 PM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > ndctl/list.c keeps track of a set of enum util_json_flags which are based
>> > on the command line options passed in.  This handling is a little messy,
>> > though.  We have an accessor function, listopts_to_flags(), which is used
>> > multiple times.  We sometimes pass the flags around as function arguments,
>> > and we also have a copy stashed in the local struct list_filter_arg called
>> > "lfa".  In some functions we access the flags in multiple ways.
>> >
>> > These flags are local to ndctl/list.c, are set exactly once per invocation
>> > and never change.  Create a variable local to that file, initialize it once
>> > and use it everywhere.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > ---
>> >  ndctl/list.c  | 54 +++++++++++++++++++++++++++---------------------------
>> >  util/filter.h |  1 -
>> >  2 files changed, 27 insertions(+), 28 deletions(-)
>>
>> I don't see the point of this thrash. It's not a win code size wise
>> and I think it needlessly adds more dependence on global variables.
>
> I disagree.  We currently have the flags value passed around as function
> arguments, we have a version stashed in a data structure we pass around, and
> we have one which is already essentially a global variable that is accessed
> via an accessor function.  Having all three is complex and unnecessary,
> especially considering that the flags never change.
>
> Can we just choose one way of accessing the flags and use it everywhere?  If
> not a global variable, which would you like to use?

The point of having them passed into the util_filter_param was in
preparation for the "ndctl monitor" work. I'd prefer to see how that
work re-uses the list helpers or what can be refactored before we
convert more code to just look at a global variable. I agree that it
is currently pointless, but we are close to adding another use of
util_filter_param, so I'd prefer to see where that goes first.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
