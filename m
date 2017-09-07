Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D2A621E977E4
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 18:05:28 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id h70so51099895oic.1
 for <linux-nvdimm@lists.01.org>; Wed, 06 Sep 2017 18:08:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907095818.7F66.E1E9C6FF@jp.fujitsu.com>
References: <150474103375.36240.17226654981174432854.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170907095818.7F66.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Sep 2017 18:08:16 -0700
Message-ID: <CAPcyv4jzNACUiWQrE=CSGFuXGMz60-3XSUd+rySgc+S1J3wfWg@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: sync with v4.13 ndctl.h
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 6, 2017 at 5:58 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> Latest ndctl.h has dropped these command definitions and we will
>> introduce a libndctl-nfit.h to carry them going forward.
>>
>> Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
>> Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  ndctl/ndctl.h |   38 +-------------------------------------
>>  1 file changed, 1 insertion(+), 37 deletions(-)
>>
>> diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
>> index d70b97da3924..5e6905c76adc 100644
>> --- a/ndctl/ndctl.h
>> +++ b/ndctl/ndctl.h
>> @@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
>>       __u64 cleared;
>>  } __attribute__((packed));
>>
>> -struct nd_cmd_trans_spa {
>> -     __u64 spa;
>> -     __u32 status;
>> -     __u8  flags;
>> -     __u8  _reserved[3];
>> -     __u64 trans_length;
>> -     __u32 num_nvdimms;
>> -     struct nd_nvdimm_device {
>> -             __u32 nfit_device_handle;
>> -             __u32 _reserved;
>> -             __u64 dpa;
>> -     } __attribute__((packed)) devices[0];
>> -
>> -} __attribute__((packed));
>> -
>> -struct nd_cmd_ars_err_inj {
>> -     __u64 err_inj_spa_range_base;
>> -     __u64 err_inj_spa_range_length;
>> -     __u8  err_inj_options;
>> -     __u32 status;
>> -} __attribute__((packed));
>> -
>> -struct nd_cmd_ars_err_inj_clr {
>> -     __u64 err_inj_clr_spa_range_base;
>> -     __u64 err_inj_clr_spa_range_length;
>> -     __u32 status;
>> -} __attribute__((packed));
>> -
>> -struct nd_cmd_ars_err_inj_stat {
>> -     __u32 status;
>> -     __u32 inj_err_rec_count;
>> -     struct nd_error_stat_query_record {
>> -             __u64 err_inj_stat_spa_range_base;
>> -             __u64 err_inj_stat_spa_range_length;
>> -     } __attribute__((packed)) record[0];
>> -} __attribute__((packed));
>> -
>>  enum {
>>       ND_CMD_IMPLEMENTED = 0,
>>
>> @@ -207,6 +170,7 @@ enum {
>>  enum {
>>       ND_ARS_VOLATILE = 1,
>>       ND_ARS_PERSISTENT = 2,
>> +     ND_ARS_RETURN_PREV_DATA = 1 << 1,
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Here seems to come from other patch.
> (This one?)
> https://patchwork.kernel.org/patch/9776249/
>
> I suppose it should be included to other patch.
>
> Other thing looks good to me.

Since this is for ND_IOCTL_ARS_START and not ND_IOCTL_CALL it needs to
stay. It's also appeared in a released kernel, so even if we wanted to
remove it we would need to go through some deprecation period until we
can be sure no userspace is dependent on it being provided by the
kernel.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
