Return-Path: <linux-nvdimm-bounces@lists.01.org>
From: Yoshimi Ichiyanagi <ichiyanagi.yoshimi@lab.ntt.co.jp>
Subject: Re: dax: enable DAX PMD suport for NVDIMM device
Date: Thu, 09 Feb 2017 15:19:48 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h4HTJmkneOAeFrhc8HM8RRp43F7nESMY53AP2mZOm5cg@mail.gmail.com>
References: <A42D2827E934C5DAD59E3A1@lab.ntt.co.jp>
 <CAPcyv4h4HTJmkneOAeFrhc8HM8RRp43F7nESMY53AP2mZOm5cg@mail.gmail.com>
Message-Id: <A45D2829C83A77AAD59E3A1@lab.ntt.co.jp>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Thank you, I could enable DAX PMD suport for HPE NVDIMM modules.

The following ndctl command changed the nvdimm device type 
from "namespace_io_device_type" to "nd_pfn_device_type", right?


I did the following: 
------
# ndctl create-namespace --reconfig=namespace1.0 --mode=memory --force
{
  "dev":"namespace1.0",
  "mode":"memory",
  "size":33820770304,
  "uuid":"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "blockdev":"pmem1"
}

# ndctl list --namespaces
{
  "provider":"ACPI.NFIT",
  "dev":"ndbus0",
  "namespaces":[
    {
      "dev":"namespace1.0",
      "mode":"memory",
      "size":33820770304,
      "uuid":"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
      "blockdev":"pmem1"
    },
    {
      "dev":"namespace0.0",
      "mode":"raw",
      "size":34359738368,
      "blockdev":"pmem0"
    }
  ]
}

# 
------


><dan.j.williams@intel.com> wrote:
>You can achieve the same by putting your namespace into "memory" mode
>with the following ndctl command.  Note that this will destroy the
>current contents of the namespace, and you must unmount /dev/pmem1
>before running this.
>
>    ndctl create-namespace --reconfig=namespace1.0 --mode=memory --force
>
>This arranges for struct page / memmap entries to be created for the 
>namespace.
>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
