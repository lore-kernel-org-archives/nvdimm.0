Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4277A22489CA8
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 06:22:15 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id x12so8572177oie.13
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 06:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180316155515.7293.E1E9C6FF@jp.fujitsu.com>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <20180316155515.7293.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Mar 2018 06:28:39 -0700
Message-ID: <CAPcyv4i9QH1eJVXnc6cwaBGPW9nNJ8nGOeDyN2icGNNJ7+O9Bg@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 11:55 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi,
>
>> > +static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
>> > +       int line, const char *fn, const char *format, va_list args)
>> > +{
>> > +       char *buf = (char *)malloc(BUF_SIZE);
>> > +       vsnprintf(buf, BUF_SIZE, format, args);
>> > +       syslog(priority, "%s", buf);
>> > +       free(buf);
>> > +}
>>
>> This seems to be reinventing setting up a log file that I'm sure we
>> could borrow or link to...
>>
>> ndctl borrows heavily from git, and git does logging in it's daemon.c,
>> I'd be happier if you copied that.
>
> Maybe silly question...., but is it OK about OSS lisence?
>
> In my understanding,  basically the lisence of git is GPL2,
> LGPL is used just for use xdiff/ or some libc code in git....
> https://github.com/git/git/blob/master/COPYING
> https://github.com/git/git/blob/master/LGPL-2.1
>
> However, the lisence of ndctl is LGPL2.1
> https://github.com/pmem/ndctl/blob/master/COPYING
>
> If we copied from git to ndctl, then I suppose that ndctl
> daemon may have to use GPL2 rather than LGPL2.1, right?

In the ndctl source tree the license of the code in ndctl/ is GPL-2,
the license of the code in ndctl/lib/ is LGPL-2.1. So we can freely
copy GPL-2 code into the utilities, but not the library.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
