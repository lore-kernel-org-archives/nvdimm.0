Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Tue, 13 Oct 2015 16:15:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
Message-ID: <20151013221530.GA17773@linux.intel.com>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
 <20151011231443.GY27164@dastard>
 <20151012214135.GA24720@linux.intel.com>
 <20151012232427.GH27164@dastard>
 <CANpvso6auD-NWsEYw10FNSviusA63tyK785usG=9R3r+a3Rirg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANpvso6auD-NWsEYw10FNSviusA63tyK785usG=9R3r+a3Rirg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Eric Curtin <ericcurtin17@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Kernel development list <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 13, 2015 at 12:35:44AM +0100, Eric Curtin wrote:
> Hi Ross,
> 
> For all those int ret declarations. Why not declare and initialize all
> on the same line?
> 
> Regards,
> Eric

Because the return value 'ret' is set unconditionally later in the function as
part of a call into the DAX code.  This call needs to be made after we've done
appropriate locking, though, which really is the point of the ext2 wrapper for
the DAX function.  Setting it to some random value and then unconditionally
overwriting it later in the function is a bad pattern because a) the initial
value is meaningless and b) it can hide coding errors where you are no longer
setting the variable to something meaningful.  The "warning: ‘ret’ is used
uninitialized in this function" warnings would otherwise warn you that you've
made a mistake.
