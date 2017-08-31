Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F25D21D2E630
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:20:37 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id r203so8567456oih.0
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831013603.16997-7-vishal.l.verma@intel.com>
References: <20170831013603.16997-1-vishal.l.verma@intel.com>
 <20170831013603.16997-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 15:23:19 -0700
Message-ID: <CAPcyv4gbU_guzNVjKnazxw5A=BTpLrQiysT2tN4EdiwcO3O8Vw@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] libnvdimm, btt: rework error clearing
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

I think we're almost there, just one more comment that you can handle
in a followup.

On Wed, Aug 30, 2017 at 6:36 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Clearing errors or badblocks during a BTT write requires sending an ACPI
> DSM, which means potentially sleeping. Since a BTT IO happens in atomic
> context (preemption disabled, spinlocks may be held), we cannot perform
> error clearing in the course of an IO. Due to this error clearing for
> BTT IOs has hitherto been disabled.
>
> In this patch we move error clearing out of the atomic section, and thus
> re-enable error clearing with BTTs. When we are about to add a block to
> the free list, we check if it was previously marked as an error, and if
> it was, we add it to the freelist, but also set a flag that says error
> clearing will be required. We then drop the lane (ending the atomic
> context), and send a zero buffer so that the error can be cleared. The
> error flag in the free list is protected by the nd 'lane', and is set
> only be a thread while it holds that lane. When the error is cleared,
> the flag is cleared, but while holding a mutex for that freelist index.
>
> When writing, we check for two things -
> 1/ If the freelist mutex is held or if the error flag is set. If so,
> this is an error block that is being (or about to be) cleared.
> 2/ If the block is a known badblock based on nsio->bb
>
> The second check is required because the BTT map error flag for a map
> entry only gets set when an error LBA is read. If we write to a new
> location that may not have the map error flag set, but still might be in
> the region's badblock list, we can trigger an EIO on the write, which is
> undesirable and completely avoidable.
>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> @@ -505,6 +546,16 @@ static int btt_freelist_init(struct arena_info *arena)
>                 arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
>                 arena->freelist[i].block = le32_to_cpu(log_new.old_map);
>
> +               /*
> +                * FIXME: if error clearing fails during init, we want to make
> +                * the BTT read-only
> +                */
> +               if (ent_e_flag(log_new.old_map)) {
> +                       ret = arena_clear_freelist_error(arena, i);
> +                       if (ret)
> +                               WARN_ONCE(1, "Unable to clear known errors\n");

WARN implies the backtrace would be interesting for this failure, for
example if the failure is likely due to a kernel software bug.
Instead, what we need here is similar to what the buffer_io_error()
helper does in fs/buffer.c. I.e. switch this to dev_err_ratelimited()
so we know which device and include the namespace physical offset that
remains busted.

This can be a follow-on because there are other usages of WARN in
btt.c that should be audited / converted to dev_WARN at a minimum, and
potentially dev_err() if the failure is not due to a software problem.

We might also want dev_err_ratelimited in the I/O path failure case,
because the administrator should know that they are continuing to see
ongoing error clearing failures.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
