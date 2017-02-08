From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] acpi,
 nfit: skip ARS on machine-check-recovery capable platforms
Date: Wed, 8 Feb 2017 09:42:30 -0800
Message-ID: <CAPcyv4hM2pz-sAcuXJTidfTMwA9sRVzCgwJjiw8ndtco8jmP=w@mail.gmail.com>
References: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x4937fopvla.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x4937fopvla.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Feb 8, 2017 at 7:10 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>
>> If the platform supports machine-check-recovery then there is little
>> reason to kick off opportunistic scrubs to collect a media error list.
>> That initial scrub is only useful when it might prevent a kernel panic
>> from consuming poison (a media error from memory).
>
> How expensive is the scrub?

The ACPI spec is not clear, but it could range from benign to
expensive and degrading system performance for 10's of minutes after
boot

> Even on platforms that support recoverable
> machine checks, it's possible that you get one that is not recoverable.
> You haven't sold me on this change.  ;-)
>

Adding Tony so he can either confirm, or point and laugh at my
assumptions. In general you're right that there are machine check
events that are not recoverable, but I'm thinking of problems like bus
lockups and other disasters out of the direct cpu-to-memory data path.
The question is whether should we avoid the cpu consuming media errors
at all costs regardless of machine-check recovery. Tony might there be
system-fatal gaps in memcpy_mcsafe() or userspace poison consumption
handling that you would recommend aggressively trying to avoid media
errors?

> Cheers,
> Jeff
>
>
>> Cc: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/acpi/nfit/core.c |    6 ++++--
>>  drivers/acpi/nfit/mce.c  |    7 +++++++
>>  drivers/acpi/nfit/nfit.h |    5 +++++
>>  3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 7361d00818e2..bbefd9516939 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -2500,10 +2500,12 @@ static void acpi_nfit_scrub(struct work_struct *work)
>>       list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
>>               /*
>>                * Flag all the ranges that still need scrubbing, but
>> -              * register them now to make data available.
>> +              * register them now to make data available. If the
>> +              * platform supports machine-check recovery then we skip
>> +              * these opportunistic scans.
>>                */
>>               if (!nfit_spa->nd_region) {
>> -                     nfit_spa->ars_required = 1;
>> +                     nfit_spa->ars_required = is_ars_required();
>>                       acpi_nfit_register_region(acpi_desc, nfit_spa);
>>               }
>>       }
>> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
>> index e5ce81c38eed..1e6f1e7100f9 100644
>> --- a/drivers/acpi/nfit/mce.c
>> +++ b/drivers/acpi/nfit/mce.c
>> @@ -92,6 +92,13 @@ static struct notifier_block nfit_mce_dec = {
>>       .notifier_call  = nfit_handle_mce,
>>  };
>>
>> +bool is_ars_required(void)
>> +{
>> +        if (static_branch_unlikely(&mcsafe_key))
>> +                return false;
>> +     return true;
>> +}
>> +
>>  void nfit_mce_register(void)
>>  {
>>       mce_register_decode_chain(&nfit_mce_dec);
>> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
>> index fc29c2e9832e..925f2a3d896e 100644
>> --- a/drivers/acpi/nfit/nfit.h
>> +++ b/drivers/acpi/nfit/nfit.h
>> @@ -211,6 +211,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
>>  #ifdef CONFIG_X86_MCE
>>  void nfit_mce_register(void);
>>  void nfit_mce_unregister(void);
>> +bool is_ars_required(void);
>>  #else
>>  static inline void nfit_mce_register(void)
>>  {
>> @@ -218,6 +219,10 @@ static inline void nfit_mce_register(void)
>>  static inline void nfit_mce_unregister(void)
>>  {
>>  }
>> +static inline bool is_ars_required(void)
>> +{
>> +     return true;
>> +}
>>  #endif
>>
>>  int nfit_spa_type(struct acpi_nfit_system_address *spa);
>>
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
