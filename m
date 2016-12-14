Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30F0581C69
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 07:55:33 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id y198so24545354oia.1
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 07:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161214150130.GE6279@linux-x5ow.site>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148143773119.10950.13840765929901351011.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20161214150130.GE6279@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Dec 2016 07:55:31 -0800
Message-ID: <CAPcyv4iwOtW69u+tAs9oXYJD2EEFcA3tzFZVK5NNS8EwFezyjg@mail.gmail.com>
Subject: Re: [PATCH 5/8] dax: refactor locking out of size calculation routines
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 14, 2016 at 7:01 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Hi Dan,
>
> On Sat, Dec 10, 2016 at 10:28:51PM -0800, Dan Williams wrote:
>> In preparation for other callers of these routines make the locking the
>> responsibility of the caller.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dax/dax.c |   30 ++++++++++++++++++++++++------
>>  1 file changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> index d878a56cf3e3..5b65eaff6ace 100644
>> --- a/drivers/dax/dax.c
>> +++ b/drivers/dax/dax.c
>> @@ -90,11 +90,11 @@ static unsigned long long dax_region_avail_size(
>>       unsigned long long size;
>>       struct resource *res;
>>
>> -     mutex_lock(&dax_region->lock);
>> +     WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
>
> I'd prefer it a lockdep_assert_held(&dex_region->lock). This of cause has the
> drawback that it won't trigger w/o lockdep but enabled, but I don't think it's
> the responibility of a production kernel to have this warnings anyway. On the
> flip side you get all the lockdep beauty for free with it.

True, yes, it's only a developer debug warning. I'll change it and fix
up the other pattern like this in libnvdimm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
