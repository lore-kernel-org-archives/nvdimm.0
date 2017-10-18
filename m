Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B6A6202E60E3
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 00:18:59 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id c77so7346312oig.0
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 00:22:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <be223a44-d3a3-7eb1-653a-c07c89b50dc5@jp.fujitsu.com>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C8E1@g01jpexmbkw01>
 <CAPcyv4g2zz8nUN8otuVNrk4VQxeQmmVcr9HsQ3CO5bFHHhNymQ@mail.gmail.com>
 <CAPcyv4iuKecnMGJG__8GCM-ONxM18cMfaGUqjXPyjuLDtXNi6Q@mail.gmail.com>
 <be223a44-d3a3-7eb1-653a-c07c89b50dc5@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Oct 2017 00:22:34 -0700
Message-ID: <CAPcyv4iXnzPYBXysSN=Ljsnxy_fDEAy+baH5sQ_fkb_6hF2diQ@mail.gmail.com>
Subject: Re: [RFC patch 1/4]ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 7:23 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>>>
>>> Let's use the same logging scheme as libndctl where we have 'struct
>>> log_ctx' and the the log function can be set to a custom routine. That
>>> way we can redirect log messages to syslog or structured json output
>>> simply by changing log_ctx.log_fn.
>>
>> Thinking further about this, using log_ctx is probably not sufficient
>> either. We'll also need metadata with each event message, see the
>> extra fields that the systemd journal tracks for inspiration:
>>
>>      https://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
>
>
> When I was trying to replace syslog with libndctl logging scheme,
> I found that libndctl logging scheme only outputs to console.
> However there is no console in a nvdimm daemon. Users can't catch
> event messages from console, we should make the outputs to files or
> syslog instead.
>
> The follow are what I want to do.
> 1) add a new function log_event() into libndctl logging scheme
> As you mentioned, using log_ctx may not be sufficient, and in order to
> make adding metadata with each event message conveniently in the future,
> I am thinking about adding log_event() into libndctl logging scheme.
> The log_event() selects destination (file or syslog) of output depends on
> configuration, and outputs messages to the destination.
>
> 2) add LOG_NOTICE into log_priority
> Since there are only LOG_INFO, LOG_ERROR and LOG_DEBUG in log_priority now,
> I am also thinking about adding LOG_NOTICE into log_priority for event messages.
> I think the LOG_INFO level is too low for the event messages of nvdimm status,
> and its event is not up to LOG_ERROR level.
>
> Here is the summary of log_event() that I can think of for now.
>
>  #define notice(x, arg...) log_notice(&(x)->ctx, ## arg)
>  #define log_notice(ctx, arg...) log_cond(ctx, LOG_NOTICE, ##arg)
>   //make the notice_out() to save event messages to output file
>  #define notice_out(x, arg...) log_notice_out(&(x)->ctx, ## arg)
>  #define log_notice_out(ctx, arg...) log_event(ctx, LOG_NOTICE, __FILE__, __LINE__, __FUNCTION__, ## arg)
>   void log_event(struct log_ctx *ctx, int priority, const char *file, int line,
>                 const char *fn, const char *format, ...)
>         // check config items
>         if(output_path){
>                 if(output_format = json)
>                         // output json format to output_path
>                 else
>                         // output text format to output_path
>         } else
>                 printf();
>
> If you agree with this idea, I will implement it asap.
> Or if I had any misunderstanding, please kindly let me know.

Yes, I think this looks on the right track. My question is whether we
need a device name for the source of the log event rather than
function name and line number. Events can be associated with the bus,
dimms, regions, or namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
