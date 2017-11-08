Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7F2C2034AB1E
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 10:44:09 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id y206so1399849oiy.4
 for <linux-nvdimm@lists.01.org>; Wed, 08 Nov 2017 10:48:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j1Jo4L=f4C_SFTXHAgfqLnmbeGrE6g+gE4oL4gx_xCow@mail.gmail.com>
References: <20171107225058.12805-1-vishal.l.verma@intel.com>
 <CAPcyv4j1Jo4L=f4C_SFTXHAgfqLnmbeGrE6g+gE4oL4gx_xCow@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Nov 2017 10:48:09 -0800
Message-ID: <CAPcyv4iMU1KUb5_S+B52b6bZXcisNmdB2PY6t8x7ANxQveMNjA@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl, nfit: Fix in/out sizes for error
 injection commands
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
Cc: "Dokupil, Dariusz" <dariusz.dokupil@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 8, 2017 at 10:07 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Nov 7, 2017 at 2:50 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> The input/output size bounds being set in the various nd_bus_cmd_new_*
>> helpers for error injection commands were larger than they needed to be,
>> and platforms could reject these. Fix the bounds to be exactly as the
>> spec describes.
>>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> ---
>>  ndctl/lib/nfit.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
>> index fb6af32..6346fd9 100644
>> --- a/ndctl/lib/nfit.c
>> +++ b/ndctl/lib/nfit.c
>> @@ -164,9 +164,9 @@ struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
>>         cmd->status = 1;
>>         pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
>>         pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
>> -       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
>> -       pkg->nd_size_out = cmd_length;
>> -       pkg->nd_fw_size = cmd_length;
>> +       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u8);
>
> How about:
>
>     pkg->nd_size_in = offset_of(struct nd_cmd_ars_err_inj, status);

Actually, something like this to make the pkg-> settings and
inter-relations clearer:

diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index 6346fd90f0e2..21c567ad5d4a 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -164,9 +164,9 @@ struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct
ndctl_bus *bus)
        cmd->status = 1;
        pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
        pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
-       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u8);
-       pkg->nd_size_out = sizeof(u32);
-       pkg->nd_fw_size = sizeof(u32);
+       pkg->nd_size_in = offsetof(struct nd_cmd_ars_err_inj, status);
+       pkg->nd_size_out = sizeof(struct nd_cmd_ars_err_inj) - pkg->nd_size_in;
+       pkg->nd_fw_size = pkg->nd_size_out;
        err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
        cmd->firmware_status = &err_inj->status;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
