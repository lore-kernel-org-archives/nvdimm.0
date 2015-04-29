Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <554143E0.7010305@hp.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182506.35812.4007.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1430331934.23761.100.camel@misato.fc.hp.com>
	<CAPcyv4jBjmvuO7EY9S13M8CUxHUUSpHR+Cy-8+F4d-+m5ZVhkg@mail.gmail.com>
	<1430333633.23761.109.camel@misato.fc.hp.com>
	<554143E0.7010305@hp.com>
Date: Wed, 29 Apr 2015 14:36:47 -0700
Message-ID: <CAPcyv4jeYnMxvAgVnuOvS8P7L3AftpRQ6trOCPuOEEHa8pSkMA@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 10/20] pmem: use ida
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hp.com>
Cc: Toshi Kani <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 29, 2015 at 1:49 PM, Linda Knippers <linda.knippers@hp.com> wrote:
> On 4/29/2015 2:53 PM, Toshi Kani wrote:
> What's the right answer for this in the long run?

Short term, /dev/disk/by-uuid to take a stable identifier from the
contents of the device.

Longer term teach udev to populate /dev/disk/by-id with stable names
for libnd devices.  The trick is identifiers for interleaved PMEM
ranges comprised of multiple physical devices.  I'm thinking something
like /dev/disk/by-id/nd-<set_cookie>
