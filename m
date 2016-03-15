Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B74B1A1F4C
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 08:39:17 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id r187so15900677oih.3
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 08:38:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160315084721.GI14621@c203.arch.suse.de>
References: <20160314233845.35672.69216.stgit@dwillia2-desk3.jf.intel.com>
 <20160315084721.GI14621@c203.arch.suse.de>
Date: Tue, 15 Mar 2016 08:38:58 -0700
Message-ID: <CAPcyv4hkGF=5ti-ZWmh5ZSXYnSG_iSnR8rCtX1HqUpdsP8bn3w@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: fix definition of conditional functionality
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 15, 2016 at 1:47 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Mon, Mar 14, 2016 at 04:38:45PM -0700, Dan Williams wrote:
>> Resolve HAVE_NDCTL_ARS and HAVE_NDCTL_CLEAR_ERROR in libndctl.h from the
>> results of configure.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  configure.ac            |   21 +++++++++++++++++++++
>>  lib/ndctl/libndctl.h.in |   20 +++++++++++---------
>>  2 files changed, 32 insertions(+), 9 deletions(-)
>>  rename lib/ndctl/{libndctl.h => libndctl.h.in} (98%)
>>
>> diff --git a/configure.ac b/configure.ac
>> index 7e006641b197..1ab376885215 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -144,6 +144,27 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
>>  )
>>  AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
>>
>> +AC_CONFIG_COMMANDS([gen-libndctl.h],
>> +             [[
>> +             if test "x$enable_ars" = "xyes"; then
>> +                     enable_ars=1
>> +             else
>> +                     enable_ars=0
>> +             fi
>> +             if test "x$enable_clear_err" = "xyes"; then
>> +                     enable_clear_err=1
>> +             else
>> +                     enable_clear_err=0
>> +             fi
>> +             sed -e s/HAVE_NDCTL_ARS/$enable_ars/ \
>> +                 -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
>> +             < lib/ndctl/libndctl.h.in > lib/ndctl/libndctl.h
>> +             ]],
>> +             [[
>> +             enable_ars=$enable_ars
>> +             enable_clear_err=$enable_clear_err
>> +             ]])
>> +
>>  AC_CHECK_HEADERS_ONCE([linux/version.h])
>>
>>  AC_CHECK_FUNCS([ \
>> diff --git a/lib/ndctl/libndctl.h b/lib/ndctl/libndctl.h.in
>> similarity index 98%
>> rename from lib/ndctl/libndctl.h
>> rename to lib/ndctl/libndctl.h.in
>> index 456288f66aee..b16f26dae535 100644
>> --- a/lib/ndctl/libndctl.h
>> +++ b/lib/ndctl/libndctl.h.in
>> @@ -148,7 +148,8 @@ int ndctl_dimm_disable(struct ndctl_dimm *dimm);
>>  int ndctl_dimm_enable(struct ndctl_dimm *dimm);
>>
>>  struct ndctl_cmd;
>> -#ifdef HAVE_NDCTL_ARS
>> +#define HAS_ARS HAVE_NDCTL_ARS
>> +#if HAS_ARS == 1
>>  struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
>>               unsigned long long address, unsigned long long len);
>>  struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars_cap, int type);
>> @@ -167,18 +168,18 @@ unsigned long long ndctl_cmd_ars_get_record_addr(struct ndctl_cmd *ars_stat,
>>  unsigned long long ndctl_cmd_ars_get_record_len(struct ndctl_cmd *ars_stat,
>>               unsigned int rec_index);
>>
>> -#ifdef HAVE_NDCTL_CLEAR_ERROR
>> +#define HAS_CLEAR_ERROR HAVE_NDCTL_CLEAR_ERROR
>> +#if HAS_CLEAR_ERROR == 1
>>  /*
>> - * clear_error requires ars_cap, so we require HAVE_NDCTL_ARS to export the
>> - * clear_error capability
>> + * clear_error requires ars_cap, so we require HAS_CLEAR_ERROR to export
>> + * the clear_error capability
>>   */
>>  struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
>>               unsigned long long len, struct ndctl_cmd *ars_cap);
>>  unsigned long long ndctl_cmd_clear_error_get_cleared(
>>               struct ndctl_cmd *clear_err);
>> -#define HAS_CLEAR_ERROR 1
>>  #endif
>> -#else /* HAVE_NDCTL_ARS */
>> +#else /* HAS_ARS == 0 */
>>  static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
>>               unsigned long long address, unsigned long long len)
>>  {
>> @@ -202,7 +203,7 @@ static inline unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap)
>>       return 0;
>>  }
>>
>> -
>> +struct ndctl_range;
>>  static inline int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
>>               struct ndctl_range *range)
>>  {
>> @@ -230,9 +231,10 @@ static inline unsigned long long ndctl_cmd_ars_get_record_len(
>>  {
>>       return 0;
>>  }
>> -#endif /* HAVE_NDCTL_ARS */
>> +#define HAS_CLEAR_ERROR 0
>> +#endif /* HAS_ARS */
>>
>> -#ifndef HAS_CLEAR_ERROR
>> +#if HAS_CLEAR_ERROR == 0
>>  static inline struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
>>               unsigned long long address, unsigned long long len,
>>               struct ndctl_cmd *ars_cap)
>>
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm@lists.01.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
> I know I'm repeating myself here, but isn't there a way to dynamically figure
> out if we can use ARS or the clear error stuff? The build host's kernel
> version doesn't necessarily reflect the capabilities of the target host's
> kernel.

Indeed, this is the default.  The only way these definitions will
disabled* is by specifying --disable-local to configure and use an old
kernel header from before these commands were defined.

Jerry is also working on some patches to provide a more generic
command passing mechanism for DIMM devices.  That also might cut down
on some of the compile-time thrash.

* Note that --enable-local is the default since this patch:
https://patchwork.kernel.org/patch/8538321/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
