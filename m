Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AA3321F7D4F8
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 09:30:40 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id v132so4053540oie.1
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 09:34:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011162449.GA20959@linux.intel.com>
References: <20171011162449.GA20959@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 09:34:08 -0700
Message-ID: <CAPcyv4hssAwJa8tf=BYVSwa8-5SSpirVUcEU+QDhH=wTE=pEGA@mail.gmail.com>
Subject: Re: nfit test deadlock
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 9:24 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Hey Dan,
>
> I was getting the ndctl unit tests working again in my setup today, and on the
> first run of ndctl's "make check" hit a deadlock.  This seems to be very easy
> to reproduce, all you have to do is specify a number of jobs to make that is
> larger than 1 (which I was accidentally doing via an alias),
> i.e. "make -j32 check"
>
> This seems to reproduce 100% of the time.
>
> I'll append the ouptut of "echo w > /proc/sysrq-trigger" to the end of this
> mail.
>
> I was using v4.13 and ndctl 58.2.

I'll take a look. Probably just need more synchronization around the
nfit_test setup/teardown path, but my recommendation for now is don't
try to run the unit tests in parallel.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
