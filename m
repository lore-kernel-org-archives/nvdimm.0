Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4A3020945611
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 12:54:17 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id a12so40361981ywh.3
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 12:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g7SSML7=KtUWWAnL0ds1E+36hMhUBuk98-N3p8cGDQCQ@mail.gmail.com>
References: <20170710155616.7319.E1E9C6FF@jp.fujitsu.com>
 <149971108315.5438.1105220261491872156.stgit@dwillia2-desk3.amr.corp.intel.com>
 <5963CAA2.3020509@hpe.com>
 <CAPcyv4g7SSML7=KtUWWAnL0ds1E+36hMhUBuk98-N3p8cGDQCQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Jul 2017 12:56:01 -0700
Message-ID: <CAPcyv4jgNf44fRkSrf1O1LZTaB599fTeXv6SJGHnWQyvOS_r=w@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl, daxctl, list: add --human option for
 number formatting
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 10, 2017 at 12:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Jul 10, 2017 at 11:42 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 07/10/2017 02:26 PM, Dan Williams wrote:
>>> The json output format of the 'list' commands is meant to make it easy
>>> to ingest the data into other tools. However, for direct administrator
>>> use of the utility provide an option to format some numbers for easier
>>> human consumption, similar to the "-h" to du(1). Note that the short
>>> option is "-u" since "-h" is already established as the short option for
>>> "--help".
>>>
>>>     Before:
>>>     # ndctl list --region=7
>>>     {
>>>       "dev":"region7",
>>>       "size":67108864,
>>>       "available_size":67108864,
>>>       "type":"pmem",
>>>       "iset_id":-6382611090938810793,
>>>       "badblock_count":8
>>>     }
>>>
>>>     After:
>>>     # ndctl list --region=7 --human
>>>     {
>>>       "dev":"region7",
>>>       "size":"64.00 MiB / 67.11 MB",
>>>       "available_size":"64.00 MiB / 67.11 MB",
>>>       "type":"pmem",
>>>       "iset_id":"0xa76c6907811fae57",
>>>       "badblock_count":8
>>>     }
>>>
>>> Cc: Dave Jiang <dave.jiang@intel.com>
>>> Reported-by: Linda Knippers <linda.knippers@hpe.com>
>>> Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>
>>> Changes since v1:
>>> * drop the auto-detect and just require the "--human" option for the
>>>   different format of the output. This prevents any confusion with
>>>   default output behavior (Yasunori)
>>>
>>> * include the JEDEC size in addition to the IEC size (i.e. MiB vs MB
>>>   etc) (Dave).
>>
>> I'd rather see us pick one or the other and not provide two values.
>> Even though this is the human friendly output, it's possible that it could
>> be used by other programs that know what MB means and know what MiB means
>> but now would need to know that / doesn't mean to divide one by the other.
>> I think as long as the units are clear, either one is ok.
>
> I started there, the thing that tipped it for me is that fio is
> currently outputting both formats when it displays size data. A script
> or another program should not be using the "--human" option, that
> should eliminate the opportunity for confusion.

How about this to get rid of the "/" character and more closely match fio?

{
  "dev":"region7",
  "size":"64.00 MiB (67.11 MB)",
  "available_size":"64.00 MiB (67.11 MB)",
  "type":"pmem",
  "iset_id":"0xa76c6907811fae57",
  "badblock_count":8
}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
