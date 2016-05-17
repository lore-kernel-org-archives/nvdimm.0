Return-Path: <linux-nvdimm-bounces@lists.01.org>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Legacy NVDIMM-F over EFI
References: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
 <CAPcyv4ioeGGe3ujkpytzJKZHDVawX95KtrFEmBvO2oaB_j_RqA@mail.gmail.com>
Date: Tue, 17 May 2016 12:19:19 -0400
In-Reply-To: <CAPcyv4ioeGGe3ujkpytzJKZHDVawX95KtrFEmBvO2oaB_j_RqA@mail.gmail.com>
 (Dan Williams's message of "Tue, 17 May 2016 08:57:09 -0700")
Message-ID: <x49inycd5dk.fsf@segfault.boston.devel.redhat.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, May 17, 2016 at 8:36 AM, Yigal Korman <yigal@plexistor.com> wrote:
>> Hi all,
>> I've got a couple of legacy 'type 12' NVDIMM-F modules in our lab I've
>> been successfully testing.

Just for clarification, NVDIMM-F is not byte-addressable persistent
memory.  I think you mean NVDIMM-N.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
