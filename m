Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <A45D2829C83A77AAD59E3A1@lab.ntt.co.jp>
References: <A42D2827E934C5DAD59E3A1@lab.ntt.co.jp>
 <CAPcyv4h4HTJmkneOAeFrhc8HM8RRp43F7nESMY53AP2mZOm5cg@mail.gmail.com>
 <A45D2829C83A77AAD59E3A1@lab.ntt.co.jp>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Feb 2017 11:05:40 -0800
Message-ID: <CAPcyv4h8VoF-iOApHezHO+SjTVY5H4dzyv7scjHTxu4Cmt_VnQ@mail.gmail.com>
Subject: Re: dax: enable DAX PMD suport for NVDIMM device
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
To: Yoshimi Ichiyanagi <ichiyanagi.yoshimi@lab.ntt.co.jp>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 8, 2017 at 10:19 PM, Yoshimi Ichiyanagi
<ichiyanagi.yoshimi@lab.ntt.co.jp> wrote:
> Thank you, I could enable DAX PMD suport for HPE NVDIMM modules.
>
> The following ndctl command changed the nvdimm device type
> from "namespace_io_device_type" to "nd_pfn_device_type", right?

Not quite... the namepsace is still namespace_io_device_type, but we
assign it to a nd_pfn_device_type instance. I.e. something like:

    echo namespace0.0 > /sys/bus/nd/devices/pfn0.0/namespace

Then when we enable that pfn0.0 device it writes metadata to
namespace0.0 indicating that the kernel should allocate memmap entries
for that address range.

> I did the following:
> ------
> # ndctl create-namespace --reconfig=namespace1.0 --mode=memory --force
> {
>   "dev":"namespace1.0",
>   "mode":"memory",
>   "size":33820770304,
>   "uuid":"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
>   "blockdev":"pmem1"
> }

Yup, looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
