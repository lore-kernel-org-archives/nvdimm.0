Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on070b.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::70b])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C519C1A1DF4
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 11:17:16 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [ndctl PATCH v2 2/4] libndctl: record dsm family in add_dimm()
Date: Thu, 15 Sep 2016 18:17:14 +0000
Message-ID: <CS1PR84MB01193D526FA8BBE4269EDB698EF00@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
 <20160913174140.10810-3-brian.boylston@hpe.com>
 <CAPcyv4gM4L42Lpm=fW+zCqR7q-SFCAnh+ZsSRjM00cHvG4-s_w@mail.gmail.com>
In-Reply-To: <CAPcyv4gM4L42Lpm=fW+zCqR7q-SFCAnh+ZsSRjM00cHvG4-s_w@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams wrote on 2016-09-14:
> On Tue, Sep 13, 2016 at 10:41 AM, Brian Boylston <brian.boylston@hpe.com> wrote:
>> The recorded DSM family can be used to provide family-specific
>> functionality.
>> 
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
>> ---
>>  ndctl/lib/libndctl.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> index 9a9dc74..c824d83 100644
>> --- a/ndctl/lib/libndctl.c
>> +++ b/ndctl/lib/libndctl.c
>> @@ -136,6 +136,7 @@ struct ndctl_dimm {
>>         unsigned short subsystem_revision_id;
>>         unsigned short manufacturing_date;
>>         unsigned char manufacturing_location;
>> +       unsigned long dsm_family;
>>         unsigned long dsm_mask;
>>         char *unique_id;
>>         char *dimm_path;
>> @@ -1145,6 +1146,11 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
>>         if (sscanf(buf, "%d:%d", &dimm->major, &dimm->minor) != 2)
>>                 goto err_read;
>>
>> +       sprintf(path, "%s/nfit/family", dimm_base);
>> +       if (sysfs_read_attr(ctx, path, buf) < 0)
>> +               goto err_read;
>> +       dimm->dsm_family = strtoul(buf, NULL, 0);
> 
> 
> Hmm I don't think it should it be fatal to add_dimm() for a failure to
> have a family.  It's reasonable for a DIMM to exist in the NFIT, but
> have no DSMs or a DSM implementation that is new to the kernel.  Can
> we make this continue on and teach consumers of ->dsm_family that it
> might be an error value?

Sure.  Some of the other values collected in add_dimm() use -1 as an
error or not available value; ok to use that for dsm_family?

Also, should I add a public accessor function such as
ndctl_dimm_get_dsm_family()?  (although there wouldn't be a consumer yet)

Thanks!
Brian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
